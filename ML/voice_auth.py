import os
import random
import numpy as np
import tensorflow as tf
import librosa
import numpy as np
from tensorflow.keras import layers, Model
from tensorflow.keras.callbacks import ModelCheckpoint
import matplotlib.pyplot as plt
import concurrent.futures

# Preprocess audio function
def preprocess_audio(audio_file, input_shape):
    y, sr = librosa.load(audio_file, sr=16000)  
    spectrogram = librosa.feature.melspectrogram(y=y, sr=sr)
    spectrogram = librosa.power_to_db(spectrogram, ref=np.max)
    spectrogram = np.expand_dims(spectrogram, axis=-1)
    # Resize spectrogram to desired shape
    spectrogram = tf.image.resize(spectrogram, input_shape[:2])
    # Pad spectrogram if necessary to ensure shape (128, 128, 1)
    pad_width = [(0, max(0, input_shape[0] - spectrogram.shape[0])), 
                 (0, max(0, input_shape[1] - spectrogram.shape[1])), 
                 (0, 0)]
    spectrogram = np.pad(spectrogram, pad_width=pad_width, mode='constant')
    return spectrogram

# Define Siamese branch with attention mechanism
def siamese_branch(input_shape):
    inputs = layers.Input(shape=input_shape)
    x = layers.Conv2D(32, (3, 3), activation='relu')(inputs)
    x = layers.MaxPooling2D(pool_size=(2, 2))(x)
    x = layers.Conv2D(64, (3, 3), activation='relu')(x)
    x = layers.MaxPooling2D(pool_size=(2, 2))(x)
    x = layers.Flatten()(x)
    x = layers.Dense(128, activation='relu')(x)
    attention_probs = layers.Dense(128, activation='softmax')(x)
    attention_mul = layers.multiply([x, attention_probs])
    return Model(inputs, attention_mul)

# Define Siamese network
def siamese_network(input_shape):
    input_1 = layers.Input(shape=input_shape)
    input_2 = layers.Input(shape=input_shape)
    shared_branch = siamese_branch(input_shape)
    output_1 = shared_branch(input_1)
    output_2 = shared_branch(input_2)
    concatenated_output = layers.concatenate([output_1, output_2])
    dot_product = layers.Dense(1, activation='sigmoid')(concatenated_output)
    return Model(inputs=[input_1, input_2], outputs=dot_product)

# Contrastive loss function
def contrastive_loss(y_true, y_pred):
    margin = 1
    square_pred = tf.square(y_pred)
    margin_square = tf.square(tf.maximum(margin - y_pred, 0))
    return tf.reduce_mean(y_true * square_pred + (1 - y_true) * margin_square)

# Function to create pairs with labels using FFT and cross-correlation in parallel
def create_pairs_with_labels_using_similarity_fft(folder_path, threshold=0.8):
    pairs = []
    files = os.listdir(folder_path)
    random.shuffle(files)
    for i in range(0, 250, 2):
        try:
            print(i)
            file_1 = files[i]
            file_2 = files[i+1]
            path_1 = os.path.join(folder_path, file_1)
            path_2 = os.path.join(folder_path, file_2)
            similarity_1 = compute_similarity_fft(path_1, path_2)
            similarity_2 = compute_similarity_fft(path_2, path_1)  # Computing in both directions for symmetry
            pairs.append((path_1, path_2, (similarity_1 + similarity_2) / 2))
        except Exception as e:
            print(f"Error processing files: {e}")
    return pairs

# Function to compute similarity between audio files using FFT and cross-correlation
def compute_similarity_fft(audio_file_1, audio_file_2):
    y1, sr1 = librosa.load(audio_file_1, sr=16000)
    y2, sr2 = librosa.load(audio_file_2, sr=16000)
    # Compute Fast Fourier Transform (FFT) of audio signals
    fft1 = np.abs(np.fft.fft(y1))
    fft2 = np.abs(np.fft.fft(y2))
    # Compute cross-correlation between FFTs
    cross_correlation = np.correlate(fft1, fft2)
    # Normalize cross-correlation
    normalized_cross_correlation = cross_correlation / (np.linalg.norm(fft1) * np.linalg.norm(fft2))
    # Compute similarity score
    similarity_score = np.max(normalized_cross_correlation)
    return similarity_score


# Function to train Siamese model with plotting
def train_siamese_model(siamese_model, pairs, batch_size, epochs, checkpoint_path):
    checkpoint_callback = ModelCheckpoint(
        filepath=checkpoint_path,
        save_weights_only=True,
        save_freq=batch_size * 10,
        verbose=1
    )
    siamese_model.compile(optimizer='adam', loss=contrastive_loss)  # Compile with contrastive loss
    for epoch in range(epochs):
        random.shuffle(pairs)
        print("Epoch:", epoch+1)
        total_loss = 0.0
        for i in range(0, len(pairs), batch_size):
            batch = pairs[i:i+batch_size]
            X1 = []
            X2 = []
            y = []
            print("Batch:", i // batch_size + 1)
            for pair in batch:
                print("Pair:", pair)
                spectrogram_1 = preprocess_audio(pair[0], input_shape)
                spectrogram_2 = preprocess_audio(pair[1], input_shape)
                X1.append(spectrogram_1)
                X2.append(spectrogram_2)
                y.append(pair[2])
                
                # Plot spectrograms of the current pair
                # plt.figure(figsize=(10, 5))
                # plt.subplot(1, 2, 1)
                # plt.imshow(spectrogram_1[:, :, 0], cmap='hot', origin='lower')
                # plt.title("Spectrogram 1")
                # plt.axis('off')
                # plt.subplot(1, 2, 2)
                # plt.imshow(spectrogram_2[:, :, 0], cmap='hot', origin='lower')
                # plt.title("Spectrogram 2")
                # plt.axis('off')
                # plt.show()
                
            X1 = np.array(X1)
            X2 = np.array(X2)
            y = np.array(y)
            print("X1 shape:", X1.shape)
            print("X2 shape:", X2.shape)
            print("y shape:", y.shape)
            loss = siamese_model.train_on_batch((X1, X2), y)
            total_loss += loss
            print("Loss:", loss)
            if (i // batch_size) % 10 == 0:
                siamese_model.save_weights(checkpoint_path.format(epoch=epoch, step=i))
        print("Average Loss for Epoch:", total_loss / (len(pairs) / batch_size))

# Example usage:
input_shape = (128, 128, 1)  
siamese_model = siamese_network(input_shape)
siamese_model.summary()
folder_path = r"C:\MY FILES\CSX\TechTitans_CSX\ML\Dataset"
# pairs = create_pairs_with_labels_using_similarity_fft(folder_path)
checkpoint_path = "./Checkpoints/siamese_model_checkpoint_epoch_{epoch}_step_{step}.weights.h5"
# train_siamese_model(siamese_model, pairs, batch_size=32, epochs=5, checkpoint_path=checkpoint_path)


# import librosa
# import numpy as np
# import tensorflow as tf

# Function to preprocess a single audio file for inference
def preprocess_single_audio(audio_file, input_shape):
    y, sr = librosa.load(audio_file, sr=16000)
    spectrogram = librosa.feature.melspectrogram(y=y, sr=sr)
    spectrogram = librosa.power_to_db(spectrogram, ref=np.max)
    spectrogram = np.expand_dims(spectrogram, axis=-1)
    spectrogram = tf.image.resize(spectrogram, input_shape[:2])
    pad_width = [(0, max(0, input_shape[0] - spectrogram.shape[0])),
                 (0, max(0, input_shape[1] - spectrogram.shape[1])),
                 (0, 0)]
    spectrogram = np.pad(spectrogram, pad_width=pad_width, mode='constant')
    return spectrogram

# Function for inference
def predict_siamese_similarity(siamese_model, audio_file_1, audio_file_2, input_shape):
    spectrogram_1 = preprocess_single_audio(audio_file_1, input_shape)
    spectrogram_2 = preprocess_single_audio(audio_file_2, input_shape)
    X1 = np.expand_dims(spectrogram_1, axis=0)
    X2 = np.expand_dims(spectrogram_2, axis=0)
    similarity_score = siamese_model.predict((X1, X2))[0][0]
    
    # Plotting the spectrograms
    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.imshow(X1[0][:,:,0], cmap='hot', origin='lower')
    plt.title("X1")
    plt.axis('off')
    plt.subplot(1, 2, 2)
    plt.imshow(X2[0][:,:,0], cmap='hot', origin='lower')
    plt.title("X2")
    plt.axis('off')
    plt.show()
    
    return similarity_score

# Example usage for inference
input_shape = (128, 128, 1)
siamese_model = siamese_network(input_shape)
siamese_model.load_weights(r"C:\MY FILES\CSX\TechTitans_CSX\ML\Checkpoints\siamese_model_checkpoint_epoch_0_step_0.weights.h5")  # Load trained weights

audio_file_1 = r"C:\MY FILES\CSX\TechTitans_CSX\ML\Dataset\p225_001.wav"
audio_file_2 = r"C:\MY FILES\CSX\TechTitans_CSX\ML\Dataset\p233_001.wav"
similarity_score = predict_siamese_similarity(siamese_model, audio_file_1, audio_file_2, input_shape)
print("Similarity score:", similarity_score)

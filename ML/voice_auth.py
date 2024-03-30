import tensorflow as tf
import librosa
from tensorflow.keras import layers, Model
import numpy as np

def preprocess_audio(audio_file, input_shape):
    # Load audio file
    y, sr = librosa.load(audio_file, sr=16000)  # Adjust sample rate as needed
    # Extract spectrogram
    spectrogram = librosa.feature.melspectrogram(y=y, sr=sr)
    spectrogram = librosa.power_to_db(spectrogram, ref=np.max)
    # Resize to input shape
    spectrogram = np.expand_dims(spectrogram, axis=-1)
    spectrogram = np.expand_dims(spectrogram, axis=0)
    spectrogram = tf.image.resize(spectrogram, input_shape[:2])
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
    
    # Attention mechanism
    attention_probs = layers.Dense(128, activation='softmax')(x)
    attention_mul = layers.multiply([x, attention_probs])
    
    return Model(inputs, attention_mul)

# Define Siamese network
def siamese_network(input_shape):
    input_1 = layers.Input(shape=input_shape)
    input_2 = layers.Input(shape=input_shape)
    
    # Shared Siamese branch
    shared_branch = siamese_branch(input_shape)
    output_1 = shared_branch(input_1)
    output_2 = shared_branch(input_2)
    
    # Compute cosine similarity
    dot_product = layers.dot([output_1, output_2], axes=1, normalize=True)
    
    return Model(inputs=[input_1, input_2], outputs=dot_product)

# Example usage
input_shape = (128, 128, 1)  # Assuming input is a spectrogram image
siamese_model = siamese_network(input_shape)
siamese_model.summary()

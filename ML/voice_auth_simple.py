from flask import Flask, request, jsonify
import numpy as np
import scipy.signal
from dtw import dtw
import librosa
import os
from pydub import AudioSegment
import matplotlib.pyplot as plt


app = Flask(__name__)
AudioSegment.converter = r"C:\FFmpeg\bin\ffmpeg.exe"

# Function to convert .m4a file to WAV format
def convert_m4a_to_wav(m4a_file):
    wav_file = os.path.splitext(m4a_file)[0] + '.wav'
    AudioSegment.from_file(m4a_file).export(wav_file, format='wav')
    return wav_file

# Function to compute combined similarity using dynamic time warping (DTW) with subsequences
def compute_combined_similarity(waveform_1, waveform_2, subsequence_length=1):
    # Compute cross-correlation
    cross_corr = np.correlate(waveform_1, waveform_2, mode='full')
    normalized_cross_corr = cross_corr / (np.linalg.norm(waveform_1) * np.linalg.norm(waveform_2))
    max_similarity_index_corr = np.argmax(normalized_cross_corr)
    max_similarity_value_corr = normalized_cross_corr[max_similarity_index_corr]

    # Compute DTW distance with subsequences
    num_subsequences = min(len(waveform_1) // subsequence_length, len(waveform_2) // subsequence_length)
    total_distance = 0
    for i in range(num_subsequences):
        start_idx = i * subsequence_length
        end_idx = (i + 1) * subsequence_length
        subseq_distance = dtw(waveform_1[start_idx:end_idx, np.newaxis], waveform_2[start_idx:end_idx, np.newaxis])
        # print(subseq_distance.distance)
        total_distance += subseq_distance.distance

    # Normalize distance
    normalized_distance = total_distance / (num_subsequences * subsequence_length)

    # Combine the similarity measures
    combined_similarity = 0.5 * max_similarity_value_corr + 0.5 * (1 - normalized_distance)
    # plot_file = 'waveforms2.png'
    # plot_waveforms(waveform_1, waveform_2, plot_file)

    # print(max_similarity_value_corr, normalized_distance)
    return combined_similarity

def plot_waveforms(waveform_1, waveform_2, plot_file):
    plt.figure(figsize=(10, 6))
    plt.subplot(2, 1, 1)
    plt.plot(waveform_1, color='blue')
    plt.title('Waveform 1')
    plt.subplot(2, 1, 2)
    plt.plot(waveform_2, color='red')
    plt.title('Waveform 2')
    plt.tight_layout()
    plt.savefig(plot_file)
    plt.close()


# Route for computing combined similarity
@app.route('/compute_similarity', methods=['POST'])
def compute_similarity():
    try:
        audio_file_1 = request.files['audio_file_1']
        audio_file_2 = request.files['audio_file_2']

        audio_file_1_wav = convert_m4a_to_wav(audio_file_1)
        audio_file_2_wav = convert_m4a_to_wav(audio_file_2)

        waveform_1, sample_rate_1 = librosa.load(audio_file_1_wav, sr=None)
        waveform_2, sample_rate_2 = librosa.load(audio_file_2_wav, sr=None)

        min_length = min(len(waveform_1), len(waveform_2))
        waveform_1 = waveform_1[:min_length]
        waveform_2 = waveform_2[:min_length]

        combined_similarity = compute_combined_similarity(waveform_1, waveform_2)

        # plot_file = 'waveforms.png'
        # plot_waveforms(waveform_1, waveform_2, plot_file)

        os.remove(audio_file_1_wav)
        os.remove(audio_file_2_wav)

        success=False
        if combined_similarity > 0.5:
            success=True
        return jsonify({'success': True, 'data': {'match': success ,'combined_similarity': combined_similarity}})
    except:
        return jsonify({'success': False})

if __name__ == '__main__':
    app.run(debug=True)

# Function to test combined similarity computation
def test_combined_similarity(file_path_1, file_path_2):
    file_path_1_wav = convert_m4a_to_wav(file_path_1)
    file_path_2_wav = convert_m4a_to_wav(file_path_2)

    waveform_1, sample_rate_1 = librosa.load(file_path_1_wav, sr=None)
    waveform_2, sample_rate_2 = librosa.load(file_path_2_wav, sr=None)

    min_length = min(len(waveform_1), len(waveform_2))
    waveform_1 = waveform_1[:min_length]
    waveform_2 = waveform_2[:min_length]

    combined_similarity = compute_combined_similarity(waveform_1, waveform_2)

    os.remove(file_path_1_wav)
    os.remove(file_path_2_wav)

    return combined_similarity

file_path_1 = "Recording.m4a"  
file_path_2 = "Recording3.m4a"
combined_similarity = test_combined_similarity(file_path_1, file_path_2)
print("Combined similarity:", combined_similarity)
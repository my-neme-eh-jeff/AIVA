from flask import Flask, request, jsonify
import os
import numpy as np
import scipy.io.wavfile as wav
from python_speech_features import mfcc
from sklearn.mixture import GaussianMixture
import pymongo
import random
from pydub import AudioSegment

app = Flask(__name__)
AudioSegment.converter = r"/home/ubuntu/Codeshastra_TechTitans/ML/ffmpeg.exe"
client = pymongo.MongoClient(
    "mongodb+srv://csx:csx_techtitans@mann.fu1ds7w.mongodb.net/?retryWrites=true&w=majority"
)
db = client["CSX"]
children_collection = db["childrens"]

def augment_audio(audio_file_path, num_augmentations=5):
    audio = AudioSegment.from_wav(audio_file_path)
    augmented_audio_files = []
    for i in range(num_augmentations):
        pitch_shift = random.uniform(-0.5, 0.5)
        speed_change = random.uniform(0.8, 1.2)
        augmented_audio = audio._spawn(
            audio.raw_data,
            overrides={
                "frame_rate": int(audio.frame_rate * speed_change),
                "sample_width": audio.sample_width,
                "frame_width": audio.frame_width,
            },
        ).set_frame_rate(audio.frame_rate)
        augmented_audio = augmented_audio._spawn(
            augmented_audio.raw_data
        ).set_frame_rate(audio.frame_rate + pitch_shift)
        augmented_audio_files.append(augmented_audio)
    return augmented_audio_files


# Function to extract MFCC features from an audio file
def extract_features(audio_file, num_mfcc=13):
    rate, audio = wav.read(audio_file)
    mfcc_features = mfcc(audio, rate, numcep=num_mfcc)
    return mfcc_features


# Function to train a GMM model
def train_gmm(features, num_components=8):
    gmm = GaussianMixture(n_components=num_components, covariance_type="diag")
    gmm.fit(features)
    return gmm


def enroll_speaker(audio_file_path, num_mfcc=13, num_components=8):
    augmented_audio_files = augment_audio(audio_file_path)
    speaker_features = np.empty((0, num_mfcc))
    for audio in augmented_audio_files:
        features = extract_features(audio.get_array_of_samples(), audio.frame_rate)
        speaker_features = np.vstack((speaker_features, features))
    gmm = train_gmm(speaker_features, num_components)
    return gmm


# Function to recognize a speaker
def recognize_speaker(audio_file_path, speaker_models):
    features = extract_features(audio_file_path)
    max_score = -np.inf
    recognized_speaker = None
    for speaker_id, gmm in speaker_models.items():
        score = gmm.score(features)
        if score > max_score:
            max_score = score
            recognized_speaker = speaker_id
    return recognized_speaker

@app.route('/home',methods=["GET"])
def home():
    return jsonify({"home":"hoe"})

@app.route("/voice-compare", methods=["POST"])
def recognize_speaker_api():
    parent_token = request.form.get("parent_token")
    if not parent_token:
        return jsonify({"error": "No parent_token provided"}), 400

    # Get all values from children collection where the parent_token is present in the parent attribute
    children_audio_files = []
    children_name = []
    print("GETTING CHILDREN")
    for child in children_collection.find({"parent": parent_token}):
        children_audio_files.append(child["audioFile"])
        children_name.append(child["name"])
    print(children_name,children_audio_files)

    # Enroll each child as a speaker
    speaker_models = {}
    for child_name, audio_file in zip(children_name, children_audio_files):
        speaker_models[child_name] = enroll_speaker(audio_file)

    audioFile=request.form.get('audioFile')
    # audio_file = request.files["audioFile"]
    # if audio_file.filename == "":
    #     return jsonify({"error": "No audio file selected"}), 400

    # Save the audio file temporarily
    # audio_path = "temp.wav"
    # audio_file.save(audio_path)

    # Recognize the speaker
    recognized_speaker = recognize_speaker(audioFile, speaker_models)
    # os.remove(audio_path)  # Remove the temporary audio file

    return jsonify({"success": True, "recognized_speaker": recognized_speaker})


if __name__ == "__main__":
    speaker_models = {}
    app.run(host='0.0.0.0',debug=True, port=8090)

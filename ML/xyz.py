import os
import shutil

def combine_folders(source_dir, target_dir):
    # Create target directory if it doesn't exist
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    # Iterate over all subdirectories and files in the source directory
    for root, dirs, files in os.walk(source_dir):
        # Iterate over files in the current directory
        for file in files:
            # Construct source file path
            source_file_path = os.path.join(root, file)
            # Construct target file path
            target_file_path = os.path.join(target_dir, file)
            # Copy the file to the target directory
            shutil.copy2(source_file_path, target_file_path)
            print(f"Copied {source_file_path} to {target_file_path}")

# Example usage:
source_directory = r"C:\MY FILES\CSX\TechTitans_CSX\ML\VoiceDataset\VCTK-Corpus\VCTK-Corpus\wav48"
target_directory = r"C:\MY FILES\CSX\TechTitans_CSX\ML\Dataset"

combine_folders(source_directory, target_directory)

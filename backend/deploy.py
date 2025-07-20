# The following script does the following:
#
# 1. Install dependencies at /the_aspiring_deva_lambda
# 2. Copy `main.py` and `src/`, and past them inside `the_aspiring_deva_lambda` directory.
# 3. Remove any __pycache__ folder inside the_aspiring_deva_lambda/src/
# 4. Zip the contents of `the_aspiring_deva_lambda` directory (all dependencies, main.py and src folder should be at top level).


import os
import shutil
import subprocess
import zipfile

DEPLOYMENT_NAME = (
    "the_aspiring_deva_lambda"  # Change this to modify both folder and zip names
)


def run_pip_install():
    # Remove existing deployment directory if it exists
    if os.path.exists(DEPLOYMENT_NAME):
        print(f"Removing existing {DEPLOYMENT_NAME} directory...")
        shutil.rmtree(DEPLOYMENT_NAME)

    # Create fresh deployment directory
    print(f"Creating new {DEPLOYMENT_NAME} directory...")
    os.makedirs(DEPLOYMENT_NAME)

    # Install dependencies
    pip_command = f"pip install -r requirements.txt --platform manylinux2014_x86_64 --target {DEPLOYMENT_NAME} --only-binary=:all:"
    subprocess.run(pip_command, shell=True, check=True)


def copy_project_files():
    # Copy main.py
    shutil.copy2("main.py", f"{DEPLOYMENT_NAME}/main.py")

    # Copy src directory
    if os.path.exists(f"{DEPLOYMENT_NAME}/src"):
        shutil.rmtree(f"{DEPLOYMENT_NAME}/src")

    shutil.copytree("src", f"{DEPLOYMENT_NAME}/src")


def remove_pycache(directory):
    for root, dirs, files in os.walk(directory):
        for dir in dirs:
            if dir == "__pycache__":
                pycache_path = os.path.join(root, dir)
                shutil.rmtree(pycache_path)
                print(f"Removed: {pycache_path}")


def create_zip():
    zip_name = f"{DEPLOYMENT_NAME}.zip"

    # Remove existing zip if it exists
    if os.path.exists(zip_name):
        os.remove(zip_name)

    # Create new zip file
    with zipfile.ZipFile(zip_name, "w", zipfile.ZIP_DEFLATED) as zipf:
        # Walk through the deployment directory
        for root, dirs, files in os.walk(DEPLOYMENT_NAME):
            for file in files:
                file_path = os.path.join(root, file)

                # Calculate archive path (relative to deployment directory)
                archive_path = os.path.relpath(file_path, DEPLOYMENT_NAME)
                zipf.write(file_path, archive_path)


def main():
    print("Starting process of lambda deployment build...")
    print(f"Using deployment name: {DEPLOYMENT_NAME}")

    print("\n1. Installing dependencies...")
    run_pip_install()

    print("\n2. Copying project files...")
    copy_project_files()

    print("\n3. Removing __pycache__ directories...")
    remove_pycache(f"{DEPLOYMENT_NAME}/src")

    print("\n4. Creating zip file...")
    create_zip()

    print("\nDeployment built successfully!")
    print(
        f"\nUpload {DEPLOYMENT_NAME}.zip to AWS Lambda (via S3 if size larger than Lambda's limit)"
    )


if __name__ == "__main__":
    main()

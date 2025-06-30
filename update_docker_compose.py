#!/usr/bin/env python3

VERSION = "1.0.0"

import json
import urllib.request
import platform

# load the JSON file

def load_json(file_path):
    with open(file_path, 'r') as file:
        return json.load(file)

# parse arguments. Input should be an optional JSON file path and path to the compose file

def parse_args():
    import argparse
    parser = argparse.ArgumentParser(description='Update Docker Compose with new images.')
    parser.add_argument("-j", '--json_file', type=str, help='Path to the JSON file containing image data. Default is remote json file on github', default='https://raw.githubusercontent.com/sdr-enthusiasts/docker-baseimage/refs/heads/main/images.json')
    parser.add_argument("-s", '--only_safe', action='store_true', help='Only include safe images')
    parser.add_argument("-c", '--compose_file', type=str, help='Path to the Docker Compose file. Default is "docker-compose.yml" in the current directory', default='docker-compose.yml')
    return parser.parse_args()

def main():
    args = parse_args()
    replaced_images = []
    arch = platform.machine()
    print(f"Running with the following arguments:\n"
          f"JSON File: {args.json_file}\n"
          f"Only Safe Images: {args.only_safe}\n"
          f"Docker Compose File: {args.compose_file}")
    print(f"Detected architecture: {arch}")

    # If the JSON file is a URL, we need to fetch it

    if not args.json_file.startswith('http'):
        data = load_json(args.json_file)
    else:
        with urllib.request.urlopen(args.json_file) as response:
            data = json.loads(response.read())

    # Check if the JSON file has a version key and if it matches the expected version
    if 'version' not in data or data['version'] != VERSION:
        print(f"Warning: The JSON file version {data.get('version', 'unknown')} does not match the expected version {VERSION}.")
        print("Please update this script via `curl -s https://raw.githubusercontent.com/sdr-enthusiasts/docker-baseimage/main/update_docker_compose.py -o update_docker_compose.py`")
        print("Exiting without making changes.")
        return

    # we want to go through the compose file. Find each line that starts with "image: " and replace the image name with the one from the JSON file IF the line contains a valid image name found in the JSON file.

    with open(args.compose_file, 'r') as file:
        compose_lines = file.readlines()
        updated_lines = []
        for line in compose_lines:
            if line.startswith("    image: "):
                replacing = False
                image_name = line.split("image: ")[1].split("/")[-1].split(":")[0].strip()
                for image in data['images']:
                    if image_name == image['name']:
                        print(f"Found matching image: {image['name']}")

                        if not args.only_safe or (args.only_safe and image[arch]):
                            replacing = True
                            line = f"    image: {image['image_build']}\n"
                            replaced_images.append(image['name'])

                if not replacing:
                    print(f"No matching image found for {image_name}, keeping original")

            updated_lines.append(line)

        with open(args.compose_file, 'w') as file:
            file.writelines(updated_lines)

    if replaced_images:
        print("Replaced images:")
        for img in replaced_images:
            print(f"- {img}")
    else:
        print("No images were replaced.")

if __name__ == "__main__":
    main()

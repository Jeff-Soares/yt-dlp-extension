import sys
import os
import json
import subprocess

desktop_path = os.path.join(os.path.join(os.environ['USERPROFILE']), 'Desktop') 

def read_message():
    raw_length = sys.stdin.buffer.read(4)
    message_length = int.from_bytes(raw_length, byteorder="little")
    message = sys.stdin.buffer.read(message_length).decode("utf-8")
    return json.loads(message)

def send_message(message):
    response = json.dumps(message).encode("utf-8")
    sys.stdout.buffer.write(len(response).to_bytes(4, byteorder="little"))
    sys.stdout.buffer.write(response)
    sys.stdout.buffer.flush()

if __name__ == "__main__":
    request = read_message()
    url = request.get("url")

    try:
        subprocess.run(["yt-dlp", "-q", url], cwd=desktop_path, check=True)
        send_message({"status": "Download finished"})
    except Exception as e:
        send_message({"error": str(e)})

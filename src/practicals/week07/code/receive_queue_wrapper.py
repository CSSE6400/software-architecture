"""
May be required in some environments to connect to the csse6400_prac queue.
"""
__author__ = "Zaidul Alam"

import subprocess
import time
import sys
import re

def run_receiver():
    cmd = [
        "docker", "run", "--rm", "-it", "--env-file", "aws.env", 
        "ghcr.io/csse6400/queue:main", "--name", "csse6400_prac", 
        "--client-name", "Client 1", "--receive"
    ]
    
    waiting_message_shown = False
    seen_messages = set()  # Track messages we've already seen
    
    while True:
        try:
            result = subprocess.run(cmd, check=False, capture_output=True, text=True)
            
            # Check for the no messages error
            if "AttributeError: 'NoneType' object has no attribute 'get'" in result.stderr:
                if not waiting_message_shown:
                    print("Waiting for messages...")
                    waiting_message_shown = True
            else:
                # Process and print stdout (messages)
                if result.stdout:
                    # Extract message content using regex
                    message_pattern = r"Client [^:]+: (.+)"
                    matches = re.findall(message_pattern, result.stdout)
                    
                    if matches:
                        waiting_message_shown = False
                        
                        # Print each new message individually
                        for message in matches:
                            # Only print messages we haven't seen before
                            if message not in seen_messages:
                                print(f"Message: {message}")
                                seen_messages.add(message)
                                # Add a small delay between messages for readability
                                time.sleep(0.5)
            
            # Wait before trying again
            time.sleep(2)
            
        except KeyboardInterrupt:
            print("\nStopping receiver...")
            break

if __name__ == "__main__":
    print("Starting SQS message receiver...")
    run_receiver()

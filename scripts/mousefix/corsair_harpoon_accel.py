#!/usr/bin/env python3

import argparse
import sys
import time
import subprocess

def detect_corsair_harpoon():
    result = subprocess.run(['xinput', 'list'], capture_output=True, text=True)
    for line in result.stdout.splitlines():
        if 'Corsair' in line and 'HARPOON' in line:
            return int(line.split('=')[1].split()[0])
    return None

def set_accel_speed(mouse_id, accel_speed):
    subprocess.run(['xinput', '--set-prop', str(mouse_id), 'libinput Accel Speed', str(accel_speed)])

def main():
    parser = argparse.ArgumentParser(description='Set acceleration speed for Corsair Harpoon mouse.')
    parser.add_argument('accel_speed', type=float, help='Acceleration speed value')
    args = parser.parse_args()

    while True:
        mouse_id = detect_corsair_harpoon()

        if mouse_id is not None:
            print(f'Corsair Harpoon mouse detected with ID: {mouse_id}')
            set_accel_speed(mouse_id, args.accel_speed)
            print(f'Acceleration speed set to {args.accel_speed} for Corsair Harpoon mouse ID: {mouse_id}')
            time.sleep(5)
        else:
            print('Corsair Harpoon mouse not detected, waiting for 5 seconds...')
            time.sleep(5)

if __name__ == '__main__':
    main()

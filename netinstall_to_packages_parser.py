#!/usr/bin/python3
import yaml

with open("netinstall.yaml", "r") as file:
	data = yaml.safe_load(file)

package_list = []

for group in data:
	if group.get("selected") or group.get("hidden"):
		for pkg in group["packages"]:
			package_list.append(pkg)

with open("packages.txt", "w") as file:
	file.write(" ".join(package_list))


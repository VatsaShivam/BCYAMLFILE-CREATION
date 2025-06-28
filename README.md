# Read & Write YAML in AL (Business Central)

# 📌 Overview
  Business Central AL now supports YAML via the existing JsonObject type:

# Read YAML:
  - JsonObject.ReadFromYaml(string)
  - JsonObject.ReadFromYaml(InStream)

# Write YAML:
  - JsonObject.WriteToYaml(string)
  - JsonObject.WriteToYaml(OutStream)

These methods let you convert YAML ↔ JSON seamlessly, read it into AL, manipulate it, and export it again 

# Use Cases
  - Data-driven testing: Easily load YAML test cases, process them as JSON, and convert back if needed .
  - CI/CD pipeline processing: Read pipeline YAML files directly in AL to drive business logic .
  - Interoperability: Convert and exchange config data between JSON and YAML formats.

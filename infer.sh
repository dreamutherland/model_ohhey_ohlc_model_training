#!/bin/bash

HOST=localhost
PORT=5000
DATA=$(cat "input_example.json")
MODEL="model-ohhey-ohlc-model-training"
PREDICTED_FEATURES="['jas_ohlc_extended__adj_close_normalised_change_1d']"


# Define colors
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[1;33m'
darker_gray_blue='\033[0;34;2m'
dark_gray_blue='\033[38;5;67m'
bronze='\033[38;5;95m'
reset='\033[0m'

echo -e "kubectl port-forward -n mlserve-$MODEL svc/$MODEL-api-service 5000:5000 2>&1 >/dev/null" | pbcopy
echo -e "\n\n   ${dark_gray_blue}copied ${darker_gray_blue}kubectl port-forward [*args]${reset} ${dark_gray_blue}to clipboard if needed.${reset}  \n\n"

response=$(curl -X POST -H "Content-Type:application/json" -s --data "{\"dataframe_split\": $DATA}" http://$HOST:$PORT/invocations)

# Use jq to extract the predictions array
predictions=($(echo "$response" | jq -r '.predictions[]'))

# Initialize variables for the largest and smallest predictions
largest="${predictions[0]}"
smallest="${predictions[0]}"

# Find the largest and smallest predictions
for prediction in "${predictions[@]}"; do
  if (( $(echo "$prediction > $largest" | bc -l) )); then
    largest="$prediction"
  elif (( $(echo "$prediction < $smallest" | bc -l) )); then
    smallest="$prediction"
  fi
done

# Print the predictions in a table with colors
echo -e "${bronze} ${PREDICTED_FEATURES} ${reset}"
echo "---------------------------------------"
for i in "${!predictions[@]}"; do
  if (( $(echo "${predictions[i]} == $largest" | bc -l) )); then
    color="$green"
  elif (( $(echo "${predictions[i]} == $smallest" | bc -l) )); then
    color="$red"
  else
    color="$yellow"
  fi
  printf "Prediction %d: ${color}%.2f${reset}\n" "$((i + 1))" "${predictions[i]}"
done
echo "---------------------------------------"

echo -e "\n   ${dark_gray_blue}ctrl-c ${darker_gray_blue}to end inference${reset}\n\n"

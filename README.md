# deploy_agent_etenna-maker

## Student Attendance Tracker Setup Script
Author: Elnathan Mulugeta
GitHub: etenna-maker

## How to Run
1. Clone this repository
2. Run: chmod +x setup_project.sh
3. Run: ./setup_project.sh
4. Enter a project name when prompted
5. Choose whether to update thresholds

## How to Trigger Archive Feature
1. Run: ./setup_project.sh
2. Enter a project name
3. Press Ctrl+C at any point during setup
4. The script will automatically:
   - Create a backup archive named attendance_tracker_{name}_archive.tar.gz
   - Delete the incomplete project folder


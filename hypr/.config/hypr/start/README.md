# HyprFlow Desktop Entry Script

## Purpose
This Bash script creates a ".desktop" file to add a new session option for the Wayland session manager Hyprland. The created file will appear in the system session selectors under the name "HyprFlow."

## How It Works
The script performs the following steps:

1. **Checks the Target Directory:**
   - Verifies the existence of the directory where the desktop entry file will be created.
   - This directory is usually located at "/usr/share/wayland-sessions".

2. **Creates a New File:**
   - Generates a ".desktop" file for the HyprFlow session.
   - Defines the session's name, description, and the command to start it.

3. **Sets File Permissions:**
   - Assigns read and write permissions (644) to the created file.

4. **Provides User Feedback:**
   - Informs the user if the file is successfully created.
   - Displays an error message if the target directory is not found.

## Usage
The script is located at: `~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh`.

1. Ensure the script is executable:
   ```bash
   chmod +x ~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh
   ```
2. Run the script with root privileges:
   ```bash
   sudo ~/.d/h/.config/hypr/start/create_hyprflow_login_entry.sh
   ```

## Example Outputs
- For a successful operation:
  ```
  New desktop entry successfully created: /usr/share/wayland-sessions/hyprflow.desktop
  ```
- In case of an error:
  ```
  Error: Target directory not found: /usr/share/wayland-sessions
  ```

## Created File Content
When executed, the script generates a file with the following content:

```plaintext
[Desktop Entry]
Name=HyprFlow
Comment=Modern Wayland Compositor
Exec=/home/kenan/.config/hypr/start/hyprland.sh
Type=Application
DesktopNames=Hyprland
```

- **Name:** Specifies the name of the session.
- **Comment:** Provides a short description of the session.
- **Exec:** Indicates the command to start the Hyprland session.
- **Type:** Defines the application type (Application).
- **DesktopNames:** Specifies the name in the session manager.

## Requirements
- Root privileges are required to run the script.
- The `/usr/share/wayland-sessions` directory must exist.
- Hyprland must be installed, and the `hyprland.sh` startup script should be properly configured.



### Wage Manager App

#### Overview
The Wage Manager app is a Flutter-based application designed to manage employee records, including working days, total salary, and amount received. This app provides a user-friendly interface for adding, updating, and viewing employee details. 

#### Features
- Add new employees with details such as name, phone number, and profile picture.
- Track the number of working days, total salary, and amount received for each employee.
- Update employee records, including their working days and salary calculations.
- View a list of all employees with their current details.
- Persistent storage using Hive for offline data management.

#### Tech Stack
- **Flutter**: The primary framework used for building the application.
- **Dart**: The programming language used in Flutter.
- **Hive**: A lightweight and fast key-value database used for local storage.
- **Image Picker**: For selecting images from the gallery or capturing photos.

#### Architecture
The app follows a simple and modular architecture:
- **Main.dart**: The entry point of the app. It initializes Hive and runs the `MyApp` widget.
- **Screens**: This contains the UI for different screens, such as the Homescreen, AddEmployeeScreen, and EmployeeDetailsScreen.
- **Models**: Defines the data structures used in the app, such as `Employee` and `WorkingDay`.
- **Services**: Contains the HiveService class for initializing and accessing the Hive database.
- **Widgets**: Reusable UI components like `EmployeeListTile` and `ReusableTextField`.
- **Utils**: Utility files for themes and constants.

#### File Descriptions
- **main.dart**: Initializes Hive and sets up the main app structure.
- **theme.dart**: Defines the app's theme and colour scheme.
- **home_screen.dart**: The main screen displays a list of employees.
- **add_employee_screen.dart**: A screen for adding a new employee.
- **employee_details_screen.dart**: A screen for viewing and updating employee details.
- **hive_service.dart**: Manages the initialization and access to the Hive database.
- **constants.dart**: Contains constant values used in the app.
- **employee_model.dart**: Defines the `Employee` and `WorkingDay` classes with Hive annotations for database storage.
- **employee_list_tile.dart**: A widget for displaying an employee in a list.
- **reusable_text_field.dart**: A reusable text field widget with validation.

# Wage Manager Flutter

A Flutter application designed to calculate and manage wage history of laborers. This app provides a comprehensive solution for tracking employee attendance, managing payments, and calculating wages efficiently.

## 📱 Features

- **Employee Management**
  - Add, edit, and delete employee records
  - Store employee photos
  - Maintain contact information
  - Track individual employee history

- **Wage Tracking**
  - Daily attendance recording
  - Automatic wage calculation
  - Payment status tracking
  - Detailed payment history

- **Smart Calculations**
  - Fixed salary rate management
  - Automatic total amount calculation
  - Paid vs. unpaid day tracking
  - Real-time payment summaries

## 🏗️ Project Structure

```
lib/
├── models/           # Data models and Hive adapters
├── repositories/     # Business logic and data operations
├── screens/         # UI screens
├── services/        # Core services (Hive, etc.)
├── utils/           # Constants and theme
└── widgets/         # Reusable UI components
```

## 🛠️ Technologies Used

### Core
- **Flutter/Dart**: Main development framework
- **Provider**: State management
- **Hive**: Local NoSQL database

### Architecture
- Repository Pattern
- Provider Pattern
- Clean Architecture principles

### Dependencies
- `provider`: State management
- `hive`: Local database
- `image_picker`: Image selection
- `material`: UI components

## 💾 Data Management

### Local Storage
- Uses Hive NoSQL database
- Offline-first architecture
- Efficient data serialization
- Persistent settings storage

### Models
- **Employee Model**
  ```dart
  class Employee {
    int id;
    String name;
    int workingDays;
    int totalAmount;
    int amountReceived;
    String? imagePath;
    String? phoneNumber;
    List<WorkingDay> workingDaysList;
  }
  ```

- **WorkingDay Model**
  ```dart
  class WorkingDay {
    DateTime date;
    bool isPaid;
  }
  ```

## 🎨 UI Components

### Custom Widgets
- Reusable text fields
- Employee list tiles
- Custom theme implementation
- Material Design components

### Theming
- Custom color scheme (Green-based)
- Consistent styling
- Responsive design
- User-friendly interface

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/umairshahid-1/Wage-Manager-Flutter.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  hive: ^2.2.3
  image_picker: ^0.8.5
```

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/umairshahid-1/Wage-Manager-Flutter/issues).


## 👤 Author

**Muhammad Umair Shahid**
- GitHub: [@umairshahid-1](https://github.com/umairshahid-1)

---
*Last updated: 2025-05-06*

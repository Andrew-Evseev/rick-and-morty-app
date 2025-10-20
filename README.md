# Rick and Morty Characters App

Flutter приложение для просмотра персонажей мультсериала "Рик и Морти" с функциями избранного и оффлайн-доступом.

## Функциональность

- 📱 **Список персонажей** с пагинацией
- ⭐ **Добавление в избранное** с анимацией
- 🔄 **Pull-to-refresh** для обновления данных
- 🌙 **Поддержка тёмной темы**
- 📂 **Экран избранного** с сортировкой
- 💾 **Локальное сохранение** данных

## Технологии

- **Flutter 3.22.0**
- **State Management**: setState + Provider (готов к подключению)
- **Локальная БД**: SQLite (sqflite)
- **HTTP клиент**: http
- **Кеширование изображений**: cached_network_image

## Установка и запуск

1. Убедитесь что установлен Flutter SDK
2. Клонируйте репозиторий
3. Установите зависимости:
```bash
flutter pub get


# 🚀 Rick and Morty Characters App

![Flutter](https://img.shields.io/badge/Flutter-3.22.0-blue)
![Dart](https://img.shields.io/badge/Dart-3.4.0-blue)

A beautiful Flutter application for browsing characters from the Rick and Morty API.

## ✨ Features
- 📱 **Character List** with infinite scroll pagination
- ⭐ **Favorites System** with smooth animations  
- 🌙 **Dark/Light Theme** toggle
- 💾 **Local Storage** with SQLite
- 🔄 **REST API Integration**
- 🎯 **Sorting** favorites by name/status

## 🛠 Tech Stack
- Flutter 3.22.0
- Dart 3.4.0
- Provider (State Management)
- SQLite (Local Database)
- HTTP (API Integration)

## 🎮 How to Run
```bash
flutter pub get
flutter run -d chrome

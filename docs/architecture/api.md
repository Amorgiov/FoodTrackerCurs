# Архитектура и API

## Общая архитектура

Приложение использует трехуровневую архитектуру:
- Клиент (Flutter)
- Облачная платформа (Firebase)
- Внешний API блюд

---

## Внешние API

### TheMealDB API
Используется для получения данных о блюдах.

Типы запросов:
- GET /categories.php
- GET /filter.php
- GET /lookup.php
- GET /search.php

---

## Firebase

### Firebase Authentication
- регистрация пользователей
- вход и выход
- восстановление пароля

### Firestore
- хранение профиля пользователя
- избранные блюда
- пробованные блюда
- блюдо дня

---

## Пример POST-запроса (Firestore)

```json
{
  "favoriteMeals": [
    {
      "mealId": "52772",
      "name": "Teriyaki Chicken",
      "thumbnail": "https://..."
    }
  ]
}

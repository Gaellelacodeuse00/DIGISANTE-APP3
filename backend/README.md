# Backend DIGISANTE

Ce backend fournit une API REST pour l'application DIGISANTE, gérant l'authentification des utilisateurs et le stockage des mesures de santé.

## Technologies utilisées
- **FastAPI** : Framework web haute performance pour Python.
- **SQLAlchemy** : ORM pour la gestion de la base de données.
- **PostgreSQL** : Base de données relationnelle (configurée par défaut sur SQLite pour une utilisation immédiate).
- **JWT** : Pour une authentification sécurisée.

## Installation et Lancement

1. Installez les dépendances :
   ```bash
   pip install fastapi uvicorn sqlalchemy psycopg2-binary passlib[bcrypt] python-jose[cryptography] python-multipart
   ```

2. Lancez le serveur :
   ```bash
   python main.py
   ```
   Le serveur sera accessible sur `http://localhost:8000`.

3. Documentation API :
   Accédez à `http://localhost:8000/docs` pour voir la documentation interactive Swagger.

## Structure de la Base de Données
Le schéma est défini dans `schema.sql`. Il comprend les tables :
- `users` : Informations de compte.
- `health_metrics` : Mesures (respiration, température, humidité, CO2).
- `notifications` : Alertes système.

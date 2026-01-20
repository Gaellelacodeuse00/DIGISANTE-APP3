-- Création de la base de données pour DIGISANTE
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS health_metrics (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    respiration_rate FLOAT, -- rpm
    temperature FLOAT, -- °C
    humidity FLOAT, -- %
    co2_level FLOAT, -- ppm
    risk_level VARCHAR(20), -- Faible, Moyen, Élevé
    measured_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insertion de données de test
INSERT INTO users (full_name, email, password_hash) VALUES 
('Jean-Marc', 'jean.marc@example.com', 'hashed_password_here');

INSERT INTO health_metrics (user_id, respiration_rate, temperature, humidity, co2_level, risk_level) VALUES
(1, 18.0, 36.8, 65.0, 420.0, 'Faible'),
(1, 17.5, 36.7, 64.0, 415.0, 'Faible'),
(1, 19.0, 37.0, 66.0, 430.0, 'Moyen');

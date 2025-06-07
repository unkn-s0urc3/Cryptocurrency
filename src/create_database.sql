-- Таблица со статусами общего назначения (например: active, inactive, banned и т.д.)
CREATE TABLE statuses (
    id SMALLSERIAL PRIMARY KEY,              -- Уникальный идентификатор (автоинкремент)
    status_name VARCHAR(30) UNIQUE NOT NULL  -- Название статуса (уникальное)
);

-- Таблица со статусами транзакций (например: pending, confirmed, failed)
CREATE TABLE transaction_statuses (
    id SMALLSERIAL PRIMARY KEY,
    transaction_status_name VARCHAR(30) UNIQUE NOT NULL
);

-- Таблица с описанием блокчейнов (например: ETH, BTC, BNB)
CREATE TABLE blockchains (
    id SMALLSERIAL PRIMARY KEY,
    symbol VARCHAR(10) UNIQUE NOT NULL,        -- Короткое имя (ETH, BTC)
    blockchain_name VARCHAR(30) UNIQUE NOT NULL -- Полное название (Ethereum, Bitcoin)
);

-- Пользователи системы
CREATE TABLE users (
    username VARCHAR(30) PRIMARY KEY,           -- Уникальное имя пользователя (логин)
    email VARCHAR(50) UNIQUE NOT NULL,          -- Уникальный email
    status_id SMALLINT NOT NULL REFERENCES statuses(id) -- Статус пользователя (foreign key)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    updated_at TIMESTAMP WITHOUT TIME ZONE,     -- Время последнего обновления
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() -- Время создания
);

-- Кошельки пользователей
CREATE TABLE wallets (
    address VARCHAR(70) PRIMARY KEY,             -- Уникальный адрес кошелька
    user_username VARCHAR(30) NOT NULL REFERENCES users(username) -- Владелец кошелька
        ON DELETE CASCADE ON UPDATE RESTRICT,
    status_id SMALLINT NOT NULL REFERENCES statuses(id) -- Статус кошелька
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Токены (например, USDT, DAI) на разных блокчейнах
CREATE TABLE tokens (
    id SMALLSERIAL PRIMARY KEY,
    blockchain_id SMALLINT NOT NULL REFERENCES blockchains(id) -- На каком блокчейне токен
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    symbol VARCHAR(10) UNIQUE NOT NULL,         -- Символ токена (USDT)
    token_name VARCHAR(30) UNIQUE NOT NULL,     -- Название токена (Tether USD)
    contract_address VARCHAR(70) UNIQUE NOT NULL -- Контракт токена (уникальный адрес)
);

-- Баланс токена на конкретном кошельке
CREATE TABLE balances (
    token_id SMALLINT NOT NULL REFERENCES tokens(id) -- Какой токен
        ON DELETE CASCADE ON UPDATE RESTRICT,
    wallet_address VARCHAR(70) NOT NULL REFERENCES wallets(address) -- У какого кошелька
        ON DELETE CASCADE ON UPDATE RESTRICT,
    amount NUMERIC(20, 8) NOT NULL,            -- Количество токенов
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    PRIMARY KEY (token_id, wallet_address)     -- Один токен на один кошелек (уникально)
);

-- Биржи (например, Binance, Kraken)
CREATE TABLE exchanges (
    id SMALLSERIAL PRIMARY KEY,
    exchange_name VARCHAR(50) UNIQUE NOT NULL,   -- Название биржи
    url VARCHAR(100) UNIQUE NOT NULL,            -- URL биржи
    status_id SMALLINT NOT NULL REFERENCES statuses(id) -- Статус (работает / не работает)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    updated_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Транзакции, связанные с биржами (например, вывод или ввод средств)
CREATE TABLE exchange_transactions (
    hash VARCHAR(70) PRIMARY KEY,                  -- Хэш транзакции
    wallet_address VARCHAR(70) NOT NULL REFERENCES wallets(address) -- Откуда
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    exchange_id SMALLINT NOT NULL REFERENCES exchanges(id) -- Какая биржа
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    recipient_address VARCHAR(70) NOT NULL,         -- Получатель (может быть внешний)
    transaction_status_id SMALLINT NOT NULL REFERENCES transaction_statuses(id) -- Статус
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    token_id SMALLINT NOT NULL REFERENCES tokens(id) -- Какой токен
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    amount NUMERIC(20, 8) NOT NULL,                 -- Сумма
    fee NUMERIC(20, 8) NOT NULL,                    -- Комиссия
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Внутренние транзакции между пользователями внутри платформы
CREATE TABLE internal_transactions (
    hash VARCHAR(70) PRIMARY KEY,                   -- Хэш транзакции
    sender_address VARCHAR(70) NOT NULL REFERENCES wallets(address) -- Отправитель
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    recipient_address VARCHAR(70) NOT NULL REFERENCES wallets(address) -- Получатель
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    transaction_status_id SMALLINT NOT NULL REFERENCES transaction_statuses(id)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    token_id SMALLINT NOT NULL REFERENCES tokens(id),
    amount NUMERIC(20, 8) NOT NULL,
    fee NUMERIC(20, 8) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);
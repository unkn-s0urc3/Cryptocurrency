CREATE TABLE users (
    username VARCHAR(30) PRIMARY KEY CHECK (username ~ '^[A-Za-z0-9_]{3,30}$'),
    email VARCHAR(100) UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    password_hash CHAR(128) NOT NULL CHECK (length(password_hash) = 128),
    password_changed_at TIMESTAMP WITHOUT TIME ZONE,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE blockchains (
    id SMALLSERIAL PRIMARY KEY,
    blockchain_name VARCHAR(30) NOT NULL UNIQUE,
    symbol VARCHAR(10) NOT NULL UNIQUE CHECK (symbol ~ '^[A-Z]{1,10}$')
);

CREATE TABLE statuses (
    id SMALLSERIAL PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE reasons (
    id SMALLSERIAL PRIMARY KEY,
    reason_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE exchanger_types (
    id SMALLSERIAL PRIMARY KEY,
    type_name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE wallets (
    wallet_address VARCHAR(70) PRIMARY KEY,
    user_username VARCHAR(30) NOT NULL REFERENCES users(username) ON DELETE CASCADE,
    status_id SMALLINT NOT NULL REFERENCES statuses(id),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE wallet_assets (
    wallet_address VARCHAR(70) NOT NULL REFERENCES wallets(wallet_address) ON DELETE CASCADE,
    blockchain_id SMALLINT NOT NULL REFERENCES blockchains(id),
    balance NUMERIC(20, 8) NOT NULL CHECK (balance >= 0),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (wallet_address, blockchain_id)
);

CREATE TABLE inactive_wallets (
    wallet_address VARCHAR(70) PRIMARY KEY REFERENCES wallets(wallet_address) ON DELETE CASCADE,
    reason_id SMALLINT NOT NULL REFERENCES reasons(id),
    deactivated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE exchangers (
    id SMALLSERIAL PRIMARY KEY,
    exchanger_name VARCHAR(50) NOT NULL,
    exchanger_type_id SMALLINT NOT NULL REFERENCES exchanger_types(id),
    exchanger_url VARCHAR(100) NOT NULL,
    CHECK (
        exchanger_url ~* '^https?://[^\s/$.?#].[^\s]*$'
        OR
        exchanger_url ~* '^http://[a-z2-7]{56}\.onion(:\d+)?(/.*)?$'
    ),
    CHECK (length(exchanger_name) > 2),
    status_id SMALLINT NOT NULL REFERENCES statuses(id),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE TABLE wallet_transactions (
    transaction_hash VARCHAR(70) PRIMARY KEY,
    wallet_address VARCHAR(70) NOT NULL REFERENCES wallets(wallet_address) ON DELETE CASCADE,
    to_address VARCHAR(70) NOT NULL,
    blockchain_id SMALLINT NOT NULL REFERENCES blockchains(id),
    amount NUMERIC(20, 8) NOT NULL CHECK (amount >= 0),
    fee NUMERIC(20, 8) NOT NULL CHECK (fee >= 0),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    CHECK (fee <= amount),
    CHECK (wallet_address IS DISTINCT FROM to_address)
);

CREATE TABLE exchanger_transactions (
    transaction_hash VARCHAR(70) NOT NULL REFERENCES wallet_transactions(transaction_hash) ON DELETE CASCADE,
    wallet_address VARCHAR(70) NOT NULL REFERENCES wallets(wallet_address) ON DELETE CASCADE,
    exchanger_id SMALLINT NOT NULL REFERENCES exchangers(id),
    PRIMARY KEY (transaction_hash, wallet_address)
);
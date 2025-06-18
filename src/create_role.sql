CREATE ROLE design
  NOSUPERUSER
  NOCREATEDB
  CREATEROLE
  NOINHERIT
  LOGIN
  NOREPLICATION
  BYPASSRLS
  CONNECTION LIMIT 1
  PASSWORD 'strong_secure_password_here';

CREATE ROLE account_manager
  NOLOGIN
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  INHERIT
  NOREPLICATION;

CREATE ROLE exchange_manager
  NOLOGIN
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  INHERIT
  NOREPLICATION;

CREATE ROLE internal_manager
  NOLOGIN
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  INHERIT
  NOREPLICATION;

CREATE ROLE assistant
  NOLOGIN
  NOSUPERUSER
  NOCREATEDB
  NOCREATEROLE
  INHERIT
  NOREPLICATION;

GRANT ALL ON TABLE balances TO design WITH GRANT OPTION;
GRANT ALL ON TABLE blockchains TO design WITH GRANT OPTION;
GRANT ALL ON TABLE exchange_transactions TO design WITH GRANT OPTION;
GRANT ALL ON TABLE exchanges TO design WITH GRANT OPTION;
GRANT ALL ON TABLE internal_transactions TO design WITH GRANT OPTION;
GRANT ALL ON TABLE statuses TO design WITH GRANT OPTION;
GRANT ALL ON TABLE tokens TO design WITH GRANT OPTION;
GRANT ALL ON TABLE transaction_statuses TO design WITH GRANT OPTION;
GRANT ALL ON TABLE users TO design WITH GRANT OPTION;
GRANT ALL ON TABLE wallets TO design WITH GRANT OPTION;
GRANT ALL ON TABLE view_account_data TO design WITH GRANT OPTION;
GRANT ALL ON TABLE view_exchange_transactions_full TO design WITH GRANT OPTION;
GRANT ALL ON TABLE view_internal_transactions_full TO design WITH GRANT OPTION;
GRANT ALL ON TABLE view_token_info TO design WITH GRANT OPTION;
GRANT ALL ON TABLE view_transactions_all TO design WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE balances TO account_manager;
GRANT SELECT ON TABLE blockchains TO account_manager;
GRANT SELECT ON TABLE statuses TO account_manager;
GRANT SELECT ON TABLE tokens TO account_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE users TO account_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE wallets TO account_manager;
GRANT SELECT ON TABLE view_account_data TO account_manager;
GRANT SELECT ON TABLE view_token_info TO account_manager;

GRANT SELECT, UPDATE ON TABLE balances TO exchange_manager;
GRANT SELECT ON TABLE blockchains TO exchange_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE exchange_transactions TO exchange_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE exchanges TO exchange_manager;
GRANT SELECT ON TABLE statuses TO exchange_manager;
GRANT SELECT ON TABLE tokens TO exchange_manager;
GRANT SELECT ON TABLE transaction_statuses TO exchange_manager;
GRANT SELECT ON TABLE users TO exchange_manager;
GRANT SELECT ON TABLE wallets TO exchange_manager;
GRANT SELECT ON TABLE view_exchange_transactions_full TO exchange_manager;
GRANT SELECT ON TABLE view_token_info TO exchange_manager;

GRANT SELECT, UPDATE ON TABLE balances TO internal_manager;
GRANT SELECT ON TABLE blockchains TO internal_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE internal_transactions TO internal_manager;
GRANT SELECT ON TABLE statuses TO internal_manager;
GRANT SELECT ON TABLE tokens TO internal_manager;
GRANT SELECT ON TABLE transaction_statuses TO internal_manager;
GRANT SELECT ON TABLE users TO internal_manager;
GRANT SELECT ON TABLE wallets TO internal_manager;
GRANT SELECT ON TABLE view_account_data TO internal_manager;
GRANT SELECT ON TABLE view_internal_transactions_full TO internal_manager;
GRANT SELECT ON TABLE view_token_info TO internal_manager;

GRANT SELECT ON TABLE balances TO assistant;
GRANT SELECT ON TABLE blockchains TO assistant;
GRANT SELECT ON TABLE exchange_transactions TO assistant;
GRANT SELECT ON TABLE exchanges TO assistant;
GRANT SELECT ON TABLE internal_transactions TO assistant;
GRANT SELECT ON TABLE statuses TO assistant;
GRANT SELECT ON TABLE tokens TO assistant;
GRANT SELECT ON TABLE transaction_statuses TO assistant;
GRANT SELECT ON TABLE users TO assistant;
GRANT SELECT ON TABLE wallets TO assistant;
GRANT SELECT ON TABLE view_account_data TO assistant;
GRANT SELECT ON TABLE view_exchange_transactions_full TO assistant;
GRANT SELECT ON TABLE view_internal_transactions_full TO assistant;
GRANT SELECT ON TABLE view_token_info TO assistant;
GRANT SELECT ON TABLE view_transactions_all TO assistant;

CREATE ROLE user_account_1 LOGIN PASSWORD 'secure_password_1';
GRANT account_manager TO user_account_1 WITH set false;

CREATE ROLE user_exchange_1 LOGIN PASSWORD 'secure_password_2';
GRANT exchange_manager TO user_exchange_1 WITH set false;

CREATE ROLE user_internal_1 LOGIN PASSWORD 'secure_password_3';
GRANT internal_manager TO user_internal_1 WITH set false;


CREATE ROLE user_assistant_1 LOGIN PASSWORD 'secure_password_4';
GRANT assistant TO user_assistant_1 WITH set false;

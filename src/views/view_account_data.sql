CREATE VIEW view_account_data AS
SELECT u.username,
       u.email,
       s.status_name AS user_status,
       w.address AS wallet_address,
       sw.status_name AS wallet_status,
       t.symbol AS token_symbol,
       b.amount AS token_amount,
       b.updated_at AS balance_updated_at
FROM users u
JOIN statuses s ON u.status_id = s.id
LEFT JOIN wallets w ON u.username = w.user_username
LEFT JOIN statuses sw ON w.status_id = sw.id
LEFT JOIN balances b ON w.address = b.wallet_address
LEFT JOIN tokens t ON b.token_id = t.id;
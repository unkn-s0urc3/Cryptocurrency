CREATE VIEW view_exchange_transactions_full AS
SELECT et.hash,
       w.user_username AS sender_username,
       et.wallet_address,
       e.exchange_name,
       et.recipient_address,
       t.symbol AS token_symbol,
       et.amount,
       et.fee,
       ts.transaction_status_name AS status,
       et.created_at
FROM exchange_transactions et
JOIN wallets w ON et.wallet_address = w.address
JOIN exchanges e ON et.exchange_id = e.id
JOIN tokens t ON et.token_id = t.id
JOIN transaction_statuses ts ON et.transaction_status_id = ts.id;

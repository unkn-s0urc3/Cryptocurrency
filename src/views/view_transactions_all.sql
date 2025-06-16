CREATE VIEW view_transactions_all AS
SELECT 
    'exchange' AS transaction_type,
    et.hash,
    w.user_username AS sender_username,
    et.recipient_address,
    e.exchange_name AS recipient_entity,
    t.symbol AS token_symbol,
    et.amount,
    et.fee,
    ts.transaction_status_name AS status,
    et.created_at
FROM exchange_transactions et
JOIN wallets w ON et.wallet_address = w.address
JOIN exchanges e ON et.exchange_id = e.id
JOIN tokens t ON et.token_id = t.id
JOIN transaction_statuses ts ON et.transaction_status_id = ts.id

UNION ALL

SELECT 
    'internal' AS transaction_type,
    it.hash,
    sw.user_username AS sender_username,
    it.recipient_address,
    rw.user_username AS recipient_entity,
    t.symbol AS token_symbol,
    it.amount,
    it.fee,
    ts.transaction_status_name AS status,
    it.created_at
FROM internal_transactions it
JOIN wallets sw ON it.sender_address = sw.address
JOIN wallets rw ON it.recipient_address = rw.address
JOIN tokens t ON it.token_id = t.id
JOIN transaction_statuses ts ON it.transaction_status_id = ts.id;

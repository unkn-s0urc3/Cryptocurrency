CREATE VIEW view_internal_transactions_full AS
SELECT it.hash,
       sw.user_username AS sender_username,
       it.sender_address,
       rw.user_username AS recipient_username,
       it.recipient_address,
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

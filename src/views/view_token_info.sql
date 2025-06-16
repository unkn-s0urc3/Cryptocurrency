CREATE VIEW view_token_info AS
SELECT t.symbol AS token_symbol,
       t.token_name,
       t.contract_address,
       b.symbol AS blockchain_symbol,
       b.blockchain_name
FROM tokens t
JOIN blockchains b ON t.blockchain_id = b.id;

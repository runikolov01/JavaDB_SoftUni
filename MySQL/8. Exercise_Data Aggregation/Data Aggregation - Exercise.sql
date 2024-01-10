-- 01. Records’ Count
SELECT COUNT(*) AS `count` 
FROM `wizzard_deposits`;

-- 02. Longest Magic Wand
SELECT MAX(magic_wand_size) AS `longest_magic_wand`
FROM `wizzard_deposits`;

-- 03. Longest Magic Wand per Deposit Groups
SELECT deposit_group, MAX(magic_wand_size) AS `longest_magic_wand`
FROM `wizzard_deposits`
GROUP BY deposit_group
ORDER BY longest_magic_wand ASC, deposit_group ASC;
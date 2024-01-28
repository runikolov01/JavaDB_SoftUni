-- 2. Get Villains’ Names
USE minions_db;
SELECT v.name, COUNT(distinct m.name) AS count
FROM villains AS v
         JOIN minions_db.minions_villains mv on v.id = mv.villain_id
         JOIN minions_db.minions m on mv.minion_id = m.id
GROUP BY v.name
HAVING count > 15;

-- 3. Get Minion Names
SELECT minions.name, age
FROM minions
         JOIN minions_db.minions_villains mv on minions.id = mv.minion_id
         JOIN minions_db.villains v on mv.villain_id = v.id
WHERE v.id = ?;

SELECT villains.name
FROM villains
WHERE id = 1;

SELECT COUNT(minions.name)
FROM minions
         JOIN minions_db.minions_villains mv on minions.id = mv.minion_id
         JOIN minions_db.villains v on mv.villain_id = v.id
WHERE v.id = 1;

SELECT COUNT(minions.name) AS count
FROM minions
         JOIN minions_db.minions_villains mv on minions.id = mv.minion_id
         JOIN minions_db.villains v on mv.villain_id = v.id
WHERE v.id = ?
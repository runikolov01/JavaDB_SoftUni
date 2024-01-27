USE minions_db;
SELECT v.name, COUNT(distinct m.name) AS count
FROM villains AS v
    JOIN minions_db.minions_villains mv on v.id = mv.villain_id
    JOIN minions_db.minions m on mv.minion_id = m.id
GROUP BY v.name
HAVING count > 15;

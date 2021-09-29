
CREATE VIEW TreeRecursive
AS
    WITH RECURSIVE Tree (node_id, parent_node_id, path, depth) AS (
        SELECT *
            FROM Nodes
            WHERE parent_node_id IS NULL
      UNION ALL
        SELECT n.*
            FROM Tree AS t
                JOIN Nodes AS n
            WHERE n.parent_node_id = t.node_id
    )
  SELECT node_id, parent_node_id, path, depth FROM Tree
;

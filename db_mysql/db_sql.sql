
SELECT n1.node_id AS id1, n1.depth as d1, n1.path AS lev1,
       n2.node_id AS id2, n2.depth as d2, n2.path as lev2,
       n3.node_id AS id3, n3.depth as d3, n3.path as lev3,
       n4.node_id as id4, n4.depth as d4, n4.path as lev4,
       n5.node_id as id5, n5.depth as d5,n5.path as lev5
           FROM Nodes AS n1
           LEFT JOIN Nodes AS n2 ON n2.parent_node_id = n1.node_id
           LEFT JOIN Nodes AS n3 ON n3.parent_node_id = n2.node_id
           LEFT JOIN Nodes AS n4 ON n4.parent_node_id = n3.node_id
           LEFT JOIN Nodes AS n5 ON n5.parent_node_id = n4.node_id
    WHERE n1.node_id=2;

SELECT n1.path
    FROM Nodes AS n1
        LEFT JOIN Nodes AS n2
            ON n1.node_id = n2.parent_node_id
    WHERE n2.node_id IS NULL;

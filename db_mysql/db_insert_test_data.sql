
USE `TreeManager`;

--| Roots |--
INSERT INTO Nodes (parent_node_id)
VALUES (NULL);

SET @tree_1_root_node_id = LAST_INSERT_ID();

INSERT INTO Nodes (parent_node_id)
VALUES (NULL);

SET @tree_2_root_node_id = LAST_INSERT_ID();

INSERT INTO Nodes (parent_node_id)
VALUES (NULL);

SET @tree_3_root_node_id = LAST_INSERT_ID();

-- Insert them to Trees --
-- INSERT INTO Trees VALUES
--     (@tree_1_root_node_id, 'tree_1_root'),
--     (@tree_2_root_node_id, 'tree_2_root'),
--     (@tree_3_root_node_id, 'tree_3_root');

--| Trees |--

/* Tree 1

0:                | Root |               
1:        | Node |         | Node |      
2:    | Node | | Node | | Node | | Node |

*/

/* Tree 2 - Schema is NOT ACTUAL

0:              | Root |
1:          | Node | | Node |
2:      | Node | | Node |
3:  | Node | | Node |

*/

/* Tree 3 - Schema is NOT ACTUAL

0:              | Root |
1:          | Node | | Node |
2:      | Node |        | Node |
3:  | Node |              | Node |

*/

-- Tree #1 ==

-- SubRoot #1
        INSERT INTO Nodes (parent_node_id)
        VALUES ( @tree_1_root_node_id );

        SET @tree_1_sub_root_1_node_id = LAST_INSERT_ID();

  -- SubRoot #1 Children (2)
        INSERT INTO Nodes (parent_node_id)
            VALUES
            ( @tree_1_sub_root_1_node_id );
        INSERT INTO Nodes (parent_node_id)
            VALUES
            ( @tree_1_sub_root_1_node_id );

-- /SubRoot #1

-- SubRoot #2
        INSERT INTO Nodes (parent_node_id)
        VALUES ( @tree_1_root_node_id );

        SET @tree_1_sub_root_2_node_id = LAST_INSERT_ID();

  -- SubRoot #2 Children (2)
    INSERT INTO Nodes (parent_node_id)
    VALUES
        ( @tree_1_sub_root_2_node_id );
    INSERT INTO Nodes (parent_node_id)
    VALUES
        ( @tree_1_sub_root_2_node_id );

-- /SubRoot #2

-- Tree #2 ==

-- SubRoot #1
    INSERT INTO Nodes (parent_node_id)
    VALUES ( @tree_2_root_node_id );

    SET @tree_2_sub_root_1_node_id = LAST_INSERT_ID();

  -- SubRoot #1->Child(1)
        INSERT INTO Nodes (parent_node_id)
        VALUES ( @tree_2_sub_root_1_node_id );

        SET @tree_2_sub_root_1_child_1_node_id = LAST_INSERT_ID();

    -- SubRoot #1->Child(1)->Children(2)
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_1_child_1_node_id );
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_1_child_1_node_id );

  -- SubRoot #1->Children(2-4)
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_1_node_id );
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_1_node_id );
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_1_node_id );

        SET @tree_2_sub_root_1_child_4_node_id = LAST_INSERT_ID();

    -- SubRoot #1->Child(4)->Children(3)
        INSERT INTO Nodes (parent_node_id)
                    VALUES
        ( @tree_2_sub_root_1_child_4_node_id );
        INSERT INTO Nodes (parent_node_id)
                    VALUES
        ( @tree_2_sub_root_1_child_4_node_id );
        INSERT INTO Nodes (parent_node_id)
                    VALUES
        ( @tree_2_sub_root_1_child_4_node_id );

-- /SubRoot #1

-- SubRoot #2
    INSERT INTO Nodes (parent_node_id)
    VALUES ( @tree_2_root_node_id );

    SET @tree_2_sub_root_2_node_id = LAST_INSERT_ID();

  -- SubRoot #2->Children(1-3)
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_2_node_id );
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_2_node_id );
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_2_node_id );

        SET @tree_2_sub_root_2_child_3_node_id = LAST_INSERT_ID();

    -- SubRoot #2->Child(3)->Children(1-2)
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_2_child_3_node_id );
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_2_child_3_node_id );
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_2_child_3_node_id );

  -- SubRoot #2->Children(4-5)
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_2_node_id );
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_2_node_id );

-- /SubRoot #2

-- SubRoot #3
    INSERT INTO Nodes (parent_node_id)
    VALUES ( @tree_2_root_node_id );

    SET @tree_2_sub_root_3_node_id = LAST_INSERT_ID();

  -- SubRoot #3->Child(1)
        INSERT INTO Nodes (parent_node_id)
                VALUES
        ( @tree_2_sub_root_3_node_id );

        SET @tree_2_sub_root_3_child_3_node_id = LAST_INSERT_ID();

    -- SubRoot #2->Child(1)->Child(1)
            INSERT INTO Nodes (parent_node_id)
                        VALUES
            ( @tree_2_sub_root_3_child_3_node_id );

        -- SubRoot #2->Child(1)->Child(1)->Child(1)
            INSERT INTO Nodes (parent_node_id)
                        VALUES
                    ( LAST_INSERT_ID() );

            -- SubRoot #2->Child(1)->Child(1)->Child(1)->Child(1)
                INSERT INTO Nodes (parent_node_id)
                            VALUES
                        ( LAST_INSERT_ID() );

-- /SubRoot #3
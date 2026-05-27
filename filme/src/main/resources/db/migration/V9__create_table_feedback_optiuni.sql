CREATE TABLE feedback_optiuni_selectate (
    id_feedback INT NOT NULL REFERENCES feedback(id_feedback) ON DELETE CASCADE,
    id_optiune INT NOT NULL REFERENCES optiuni_feedback(id_optiune) ON DELETE CASCADE,
    PRIMARY KEY (id_feedback, id_optiune)
);
USE Loan_Approval

SELECT DB_NAME() AS Current_Database;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


-- table name change
EXEC sp_rename 'dbo.Loan_approval_final', 'loans';


SELECT TOP 5
    Credit_Score_Band,
    Income_Band,
    DTI_Band,
    Risk_Flag,
    Loan_Approved,
    Approved_Amount
FROM loans;

-- Multi-factor approval Analysis

SELECT
    Credit_Score_Band,
    Income_Band,
    DTI_Band,
    Risk_Flag,

    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate,

    ROUND(AVG(Approved_Amount), 2) AS Avg_Approved_Amount

FROM loans

GROUP BY
    Credit_Score_Band,
    Income_Band,
    DTI_Band,
    Risk_Flag

ORDER BY Approval_Rate DESC;


-- High-Risk Approved Loans

SELECT
    Default_Risk,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate

FROM loans
GROUP BY Default_Risk
ORDER BY Approval_Rate DESC;

-- Credit Risk Exposure

SELECT
    SUM(Approved_Amount) AS Total_Approved_Amount,

    SUM(
        CASE
            WHEN Default_Risk = 'High'
            THEN Approved_Amount
            ELSE 0
        END
    ) AS High_Risk_Approved_Amount,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Default_Risk = 'High'
                THEN Approved_Amount
                ELSE 0
            END
        ) / NULLIF(SUM(Approved_Amount), 0),
        2
    ) AS High_Risk_Exposure_Percentage

FROM loans
WHERE Loan_Approved = 'Approved';

-- Approval Performance by Application Channel

SELECT
    Application_Channel,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate

FROM loans
GROUP BY Application_Channel
ORDER BY Approval_Rate DESC;

-- Approval Performance by Region

SELECT
    Region,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) / COUNT(*),
    2) AS Approval_Rate,

    ROUND(
        AVG(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
            END
        ),
        2
    ) AS Avg_Approved_Amount

FROM loans
GROUP BY Region
ORDER BY Approval_Rate DESC;



-- Approval Amount by Employment Status

SELECT
    Employment_Status,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate,

    ROUND(
        AVG(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
            END
        ),
        2
    ) AS Avg_Approved_Amount

FROM loans
GROUP BY Employment_Status
ORDER BY Avg_Approved_Amount DESC;



-- Previous Loan History vs Approval

SELECT
    Previous_Loan_Status,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate

FROM loans
GROUP BY Previous_Loan_Status
ORDER BY Approval_Rate DESC;

-- Collateral & Co-Applicant Impact

SELECT
    Collateral,
    Co_Applicant,

    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate,

    ROUND(
        AVG(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
            END
        ),
        2
    ) AS Avg_Approved_Amount

FROM loans
GROUP BY
    Collateral,
    Co_Applicant
ORDER BY Approval_Rate DESC;


-- Loan Purpose Analysis

SELECT
    Loan_Purpose,
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Approval_Rate,

    ROUND(
        AVG(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
            END
        ),
        2
    ) AS Avg_Approved_Amount

FROM loans
GROUP BY Loan_Purpose
ORDER BY Approval_Rate DESC;


-- Executive Loan Portfolio Summary

SELECT
    COUNT(*) AS Total_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved' THEN 1
            ELSE 0
        END
    ) AS Approved_Applications,

    SUM(
        CASE
            WHEN Loan_Approved = 'Rejected' THEN 1
            ELSE 0
        END
    ) AS Rejected_Applications,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN Loan_Approved = 'Approved' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS Overall_Approval_Rate,

    ROUND(
        SUM(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
                ELSE 0
            END
        ),
        2
    ) AS Total_Approved_Amount,

    ROUND(
        AVG(
            CASE
                WHEN Loan_Approved = 'Approved'
                THEN Approved_Amount
            END
        ),
        2
    ) AS Avg_Approved_Amount,

    SUM(
        CASE
            WHEN Loan_Approved = 'Approved'
             AND Default_Risk = 'High'
            THEN Approved_Amount
            ELSE 0
        END
    ) AS High_Risk_Approved_Amount

FROM loans;


SELECT COUNT(*) AS Total_Rows
FROM loans;

SELECT
    Application_ID,
    COUNT(*) AS Duplicate_Count
FROM loans
GROUP BY Application_ID
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Credit_Score_Band) AS Credit_Band_Not_Null,
    COUNT(Income_Band) AS Income_Band_Not_Null,
    COUNT(DTI_Band) AS DTI_Band_Not_Null,
    COUNT(Risk_Flag) AS Risk_Flag_Not_Null,
    COUNT(Loan_Approved) AS Approval_Not_Null,
    COUNT(Approved_Amount) AS Approved_Amount_Not_Null
FROM loans;

SELECT
    Loan_Approved,
    COUNT(*) AS Applications,
    MIN(Approved_Amount) AS Min_Approved_Amount,
    MAX(Approved_Amount) AS Max_Approved_Amount,
    AVG(Approved_Amount) AS Avg_Approved_Amount
FROM loans
GROUP BY Loan_Approved;


SELECT @@SERVERNAME AS Server_Name;
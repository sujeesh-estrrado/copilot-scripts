IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Balancesheet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Balancesheet]
        (
            @FromDate datetime = NULL,
            @ToDate datetime = NULL
        )
        AS
        BEGIN

            SELECT
                Payment_Details_Particulars,
                SUM(CashBookTotal) AS CashBook,
                SUM(BankBookTotal) AS BankBook,
                SUM(Income) AS Income,
                SUM(Expense) AS Expense
            FROM
            (
                SELECT   
                    CASE WHEN Payment_Details_Mode = 1 THEN SUM(Payment_Details_Amount) ELSE 0 END AS CashBookTotal,
                    CASE WHEN Payment_Details_Mode = 2 THEN SUM(Payment_Details_Amount) 
                         WHEN Payment_Details_Mode = 3 THEN SUM(Payment_Details_Amount) 
                         ELSE 0 END AS BankBookTotal,
                    p.Payment_Details_Particulars,
                    ISNULL(CASE WHEN Payment_Details_Spend_Or_Receive = 1 THEN P.Payment_Details_Amount END, 0) AS Income,
                    ISNULL(CASE WHEN Payment_Details_Spend_Or_Receive = 0 THEN P.Payment_Details_Amount END, 0) AS Expense,
                    P.Payment_Details_Date
                FROM Tbl_Payment_Details p
                INNER JOIN Tbl_Payment_Cash_Book c ON c.Payment_Details_Id = p.Payment_Details_Id
                WHERE CONVERT(VARCHAR(10), Cash_Book_Date, 101) BETWEEN
                    ISNULL(@FromDate, (SELECT MIN(CONVERT(VARCHAR(10), Cash_Book_Date, 101)) FROM Tbl_Payment_Cash_Book)) AND
                    ISNULL(@ToDate, (SELECT MAX(CONVERT(VARCHAR(10), Cash_Book_Date, 101)) FROM Tbl_Payment_Cash_Book))
                    AND Payment_Details_Del_Status = 0 AND Cash_Book_Status = 0
                GROUP BY Payment_Details_Mode, p.Payment_Details_Particulars,
                    P.Payment_Details_Particulars_Id, P.Payment_Details_Spend_Or_Receive,
                    P.Payment_Details_Date, Payment_Details_Amount, Cash_Book_Date

                UNION

                SELECT
                    CASE WHEN Payment_Details_Mode = 1 THEN SUM(Payment_Details_Amount) ELSE 0 END AS CashBookTotal,
                    CASE WHEN Payment_Details_Mode = 2 THEN SUM(Payment_Details_Amount) 
                         WHEN Payment_Details_Mode = 3 THEN SUM(Payment_Details_Amount) 
                         ELSE 0 END AS BankBookTotal,
                    p.Payment_Details_Particulars,
                    ISNULL(CASE WHEN Payment_Details_Spend_Or_Receive = 1 THEN P.Payment_Details_Amount END, 0) AS Income,
                    ISNULL(CASE WHEN Payment_Details_Spend_Or_Receive = 0 THEN P.Payment_Details_Amount END, 0) AS Expense,
                    P.Payment_Details_Date
                FROM Tbl_Payment_Details p
                INNER JOIN Tbl_Payment_Bank_Book b ON b.Payment_Details_Id = p.Payment_Details_Id
                WHERE CONVERT(VARCHAR(10), Bank_Book_Date, 101) BETWEEN
                    ISNULL(@FromDate, (SELECT MIN(CONVERT(VARCHAR(10), Bank_Book_Date, 101)) FROM Tbl_Payment_Bank_Book)) AND
                    ISNULL(@ToDate, (SELECT MAX(CONVERT(VARCHAR(10), Bank_Book_Date, 101)) FROM Tbl_Payment_Bank_Book))
                    AND Payment_Details_Del_Status = 0 AND Bank_Book_Status = 0
                GROUP BY Payment_Details_Mode, p.Payment_Details_Particulars,
                    P.Payment_Details_Particulars_Id, P.Payment_Details_Spend_Or_Receive,
                    P.Payment_Details_Date, Payment_Details_Amount, Bank_Book_Date
            ) AS TEMP
            GROUP BY Payment_Details_Particulars

        END
    ')
END

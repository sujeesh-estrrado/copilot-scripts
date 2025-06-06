IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectIndividualStudentFeeReportSub_new_FINAL]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_SelectIndividualStudentFeeReportSub_new_FINAL] 
        @candidateId BIGINT,
        @intake BIGINT
        AS
        BEGIN
            DECLARE @CANDIDATE_ID INT;
            DECLARE @INTAKE_ID INT;
            DECLARE @COUNTS INT;
            DECLARE @LOOPCOUNT INT;
            DECLARE @FEE_ENTRY_ID INT;
            DECLARE @TAGDESC VARCHAR(50);
            DECLARE @TRANSFERAMOUNT DECIMAL(18,2);

            --SET @CANDIDATE_ID = 412;
            --SET @INTAKE_ID = 11846;

            --DROP TABLE #NOTRASFER_IN_OR_OUT;
            CREATE TABLE #NOTRASFER_IN_OR_OUT (
                MID INT IDENTITY(1,1) PRIMARY KEY,
                FEE_HEAD_ID INT,
                FeeHeadName VARCHAR(100),
                AMOUNT DECIMAL(18,2),
                ITEMDESC VARCHAR(100),
                DISCOUNT DECIMAL(18,2),
                REFOUND DECIMAL(18,2),
                WAIVED DECIMAL(18,2),
                ITEMDESCR VARCHAR(100),
                CURRECNCY INT,
                PAID DECIMAL(18,2),
                DATE DATETIME,
                CURRENCYCODE VARCHAR(50),
                FEEENTRYID INT,
                CANDIDATEiD INT,
                INTAKE_ID INT,
                PAID1 DECIMAL(18,2),
                DATE1 DATETIME,
                FEEENTRYiDS INT,
                AMOUNT1 DECIMAL(18,2)
            );

            INSERT INTO #NOTRASFER_IN_OR_OUT 
                (FEE_HEAD_ID, FeeHeadName, AMOUNT, ITEMDESC, DISCOUNT, REFOUND, WAIVED, ITEMDESCR, CURRECNCY, PAID, DATE, CURRENCYCODE, CANDIDATEiD, INTAKE_ID, FEEENTRYID, PAID1, DATE1, AMOUNT1)
            EXEC Sp_SelectIndividualStudentFeeReportSub_new1testing @candidateId, @intake;

            ALTER TABLE #NOTRASFER_IN_OR_OUT 
            ADD T_IN VARCHAR(50) NULL, TIN_AMOUNT INT NULL, T_OUT VARCHAR(50) NULL, TOUT_AMOUNT INT NULL;

            SET @COUNTS = (SELECT COUNT(MID) FROM #NOTRASFER_IN_OR_OUT);
            SET @LOOPCOUNT = 1;

            WHILE (@LOOPCOUNT <= @COUNTS)
            BEGIN
                SET @FEE_ENTRY_ID = (SELECT T.FEEENTRYID FROM #NOTRASFER_IN_OR_OUT AS T WHERE T.MID = @LOOPCOUNT);
                SET @TAGDESC = (SELECT TagDescription FROM dbo.Tbl_Fee_Entry WHERE Fee_Entry_Id = @FEE_ENTRY_ID);
                SET @TRANSFERAMOUNT = (SELECT Paid FROM dbo.Tbl_Fee_Entry WHERE Fee_Entry_Id = @FEE_ENTRY_ID);

                IF (@TAGDESC = ''TRANSFER IN'')
                BEGIN
                    UPDATE #NOTRASFER_IN_OR_OUT SET T_IN = ''TRANSFER IN'' WHERE FEEENTRYID = @FEE_ENTRY_ID;
                    UPDATE #NOTRASFER_IN_OR_OUT SET TIN_AMOUNT = @TRANSFERAMOUNT WHERE FEEENTRYID = @FEE_ENTRY_ID;
                    UPDATE #NOTRASFER_IN_OR_OUT SET PAID = 0.00 WHERE FEEENTRYID = @FEE_ENTRY_ID;
                END

                IF (@TAGDESC = ''TRANSFER OUT'')
                BEGIN
                    UPDATE #NOTRASFER_IN_OR_OUT SET T_OUT = ''TRANSFER OUT'' WHERE FEEENTRYID = @FEE_ENTRY_ID;
                    UPDATE #NOTRASFER_IN_OR_OUT SET TOUT_AMOUNT = @TRANSFERAMOUNT WHERE FEEENTRYID = @FEE_ENTRY_ID;
                    UPDATE #NOTRASFER_IN_OR_OUT SET PAID = 0.00 WHERE FEEENTRYID = @FEE_ENTRY_ID;
                END

                SET @LOOPCOUNT = @LOOPCOUNT + 1;
            END

            DELETE FROM Tbl_SelectIndividualStudentFeeReportSub_new_FINAL;

            INSERT INTO Tbl_SelectIndividualStudentFeeReportSub_new_FINAL
                (Id, FeeHead_id, FeeHeadName, Amount, ItemDesc, discount, Refund, Waived, ItemDescr, Currency, Paid, date, CurrencyCode, FeeEntryId, Candidate_Id, IntakeId, Paid1, Date1, FeeEntryId1, Amount1, TransferIn, TransferInAmount, TransferOut, TranferOutAmount)
            SELECT * FROM #NOTRASFER_IN_OR_OUT;

            SELECT * FROM Tbl_SelectIndividualStudentFeeReportSub_new_FINAL;
        END
    ');
END

-- Check and create 'Get_Autoinvoice_dtls' procedure dynamically
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Autoinvoice_dtls]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_Autoinvoice_dtls]
    @Candidate_Id INT,
    @flag INT,
    @prgmid INT,
    @newadmissionid INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @flag = 1
    BEGIN 
       select cpd.New_Admission_Id,d.Department_Name,na.Department_Id from Tbl_Candidate_Personal_Det cpd 
     left join tbl_New_Admission na on na.New_Admission_Id = cpd.New_Admission_Id
     left join Tbl_Department d on d.Department_Id =  na.Department_Id
        WHERE cpd.Candidate_Id = @Candidate_Id;
    END

    IF @flag = 2
    BEGIN 
       select FGT.accountcodeid AS Account_CodeID,RA.name AS Account_Code,FGT.semester,FGT.amountintl,FGT.amountlocal,CPD.TypeOfStudent from fee_group FG 
    LEFT JOIN  
        [fee_group_item] FGT ON FGT.groupid = FG.groupid 
        LEFT JOIN 
        [ref_accountcode] RA ON RA.ID = FGT.accountcodeid 
        LEFT JOIN 
        tbl_new_admission NA ON na.Batch_Id = FG.programIntakeID 
    LEFT JOIN 
        Tbl_Candidate_Personal_Det CPD ON CPD.New_Admission_Id = na.New_Admission_Id
    WHERE fg.PROGRAMID=@prgmid and na.New_Admission_Id=@newadmissionid and cpd.Candidate_Id =@Candidate_Id and fg.deleteStatus = 0 and FGT.deleteStatus = 0 
    GROUP BY 
    FGT.accountcodeid,
    RA.name,
    FGT.semester,
    FGT.amountintl,
    FGT.amountlocal,
    CPD.TypeOfStudent;
    END
    
END;
    ')
END;
GO

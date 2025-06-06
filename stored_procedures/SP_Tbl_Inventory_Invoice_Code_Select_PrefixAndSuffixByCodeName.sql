IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Invoice_Code_Select_PrefixAndSuffixByCodeName]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Inventory_Invoice_Code_Select_PrefixAndSuffixByCodeName]
@Invoice_Code_Name varchar(100),
@prgmcode varchar(10)
AS
BEGIN
IF EXISTS (
        SELECT program_code
        FROM Tbl_Inventory_Invoice_Code
        WHERE Invoice_Code_Name = @Invoice_Code_Name
          AND Invoice_Code_Del_Status = 0
          AND program_code = @prgmcode
    )
    BEGIN
SELECT 
Invoice_Code_Id,
Invoice_Code_Prefix,
Invoice_Code_Suffix,
Invoice_Code_StartNo,
Prefix1,
Prefix2,Prefix3
From  Tbl_Inventory_Invoice_Code 
Where Invoice_Code_Name=@Invoice_Code_Name and Invoice_Code_Del_Status=0 and LTRIM(RTRIM(program_code)) = LTRIM(RTRIM(@prgmcode)) and  (GETDATE() BETWEEN (Invoice_Code_From_Date) and (Invoice_Code_To_Date ))
END
    -- Additional check if @Invoice_Code_Name is ''Admission Number''
    ELSE IF @Invoice_Code_Name = ''Admission Number''
    BEGIN
        SELECT 
            Invoice_Code_Id,
            Invoice_Code_Prefix,
            Invoice_Code_Suffix,
            Invoice_Code_StartNo,
            Prefix1,
            Prefix2,
            Prefix3
        FROM Tbl_Inventory_Invoice_Code 
        
Where Invoice_Code_Name=@Invoice_Code_Name and Invoice_Code_Del_Status=0 and LTRIM(RTRIM(program_code)) = LTRIM(RTRIM(@prgmcode)) and  (GETDATE() BETWEEN (Invoice_Code_From_Date) and (Invoice_Code_To_Date ))
END


ELSE
    BEGIN
    SELECT 
Invoice_Code_Id,
Invoice_Code_Prefix,
Invoice_Code_Suffix,
Invoice_Code_StartNo,
Prefix1,
Prefix2,Prefix3
From  Tbl_Inventory_Invoice_Code 
Where Invoice_Code_Name=@Invoice_Code_Name and Invoice_Code_Del_Status=0 and (GETDATE() BETWEEN (Invoice_Code_From_Date) and (Invoice_Code_To_Date ))
END
END
    ')
END

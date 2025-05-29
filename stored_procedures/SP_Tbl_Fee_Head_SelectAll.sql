IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Fee_Head_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Fee_Head_SelectAll]          
AS          
BEGIN          
SELECT 
Fee_Head_Id,
Fee_Head_Name,
Fee_Head_Type_Id,
Fee_Head_Hosteller,
Fee_Head_Dayscholar,
Fee_Head_Refundable,
Fee_Head_DelStatus
From Tbl_Fee_Head Where Fee_Head_DelStatus=0
END

   ')
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GroupReceipt_ExcelLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_GroupReceipt_ExcelLog]
( 
     @Excel_Name   varchar (max) ,
     @Upload_Date   datetime  ,
     @User_Id   bigint  ,
     @Bank   bigint  ,
     @methodof_Payment   bigint  ,
     @Receipt_Type   varchar (max) ,
     @Provider_Id   bigint  

)
as
begin
    
        Insert into Tbl_GroupReceipt_ExcelLog( 
     Excel_Name ,
     Upload_Date,
     User_Id,
     Bank ,
     methodof_Payment,
     Receipt_Type,
     Provider_Id,
     Created_Date,
     Delete_Status)
Values( 
     @Excel_Name ,
     @Upload_Date,
     @User_Id,
     @Bank ,
     @methodof_Payment,
     @Receipt_Type,
     @Provider_Id,
     getdate(),
     0 )
        
        
end
    ')
END;

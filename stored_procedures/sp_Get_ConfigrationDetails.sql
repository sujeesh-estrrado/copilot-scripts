IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_ConfigrationDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_Get_ConfigrationDetails] --1,2,1      
     
as      
begin      
     
select * from Tbl_Configuration_Settings where Config_Type=''AdmissionFeeMapping'' and Config_Status=''true''    
     
end     ')
END

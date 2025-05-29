IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_HostelBlock_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_HostelBlock_id]
(@hostelid bigint)
    
      
AS      
      
BEGIN      
      
 SELECT  Block_Id,Block_Name,Block_Code      
  FROM dbo.Tbl_Hostel_Block where Block_DelStatus=0   and Hostel_Id=@hostelid
order by Block_Name    
         
END
   ');
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Organization_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Organization_ByID]    
(    
@OrganizationId varchar(10)    
)     
as begin      
select * from  dbo.Tbl_Organzation where      
Organization_Id=@OrganizationId and    
Organization_DelStatus=0    
end
    ')
END

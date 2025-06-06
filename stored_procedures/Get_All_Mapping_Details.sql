IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_Mapping_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_All_Mapping_Details]   
        @Department_Id BIGINT
        AS    
        BEGIN
           

            SELECT 
                FDM.*, 
                R.Room_Name, 
                API.*  
            FROM dbo.tbl_Facility_Department_Mapping FDM
            INNER JOIN dbo.Tbl_Room R ON R.Room_Id = FDM.Room_Id
            INNER JOIN dbo.Tb_Asset_Facility_Mapping AFM ON AFM.Room_Id = R.Room_Id
            INNER JOIN dbo.Tbl_Asset_Product_Id API ON API.Asset_Product_Id = AFM.Asset_Product_Id
            WHERE FDM.Department_Id = @Department_Id;
        END;
    ')
END;

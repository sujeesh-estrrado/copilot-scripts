IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_Mapping_Room]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_All_Mapping_Room]
        @RoomId BIGINT
        AS
        BEGIN
         
            
            SELECT 
                Ap.Product_Id_Number, 
                R.Room_Name, 
                Tbl_Products.Product_Name 
            FROM Tb_Asset_Facility_Mapping Am
            INNER JOIN Tbl_Asset_Product_Id Ap ON Ap.Asset_Product_Id = Am.Asset_Product_Id
            INNER JOIN Tbl_Products ON Tbl_Products.Product_Id = Ap.Product_Id
            INNER JOIN Tbl_Room R ON R.Room_Id = Am.Room_Id
            WHERE Am.Room_Id = @RoomId;
        END
    ')
END;

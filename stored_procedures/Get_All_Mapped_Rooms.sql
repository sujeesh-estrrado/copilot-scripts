IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_Mapped_Rooms]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Get_All_Mapped_Rooms]
        (
            @RoomID BIGINT
        )  
        AS  
        BEGIN  
            

            SELECT 
                Am.MappingID,
                Ap.Product_Id_Number,
                Am.Room_Id AS RoomID,
                R.Room_Name + '' - '' + Tbl_Floor.Floor_Name + '' - '' + Tbl_Block.Block_Name AS Room_Name,
                Tbl_Products.Product_Name,
                Am.Asset_Product_Id 
            FROM Tb_Asset_Facility_Mapping Am  
            INNER JOIN Tbl_Asset_Product_Id Ap ON Ap.Asset_Product_Id = Am.Asset_Product_Id  
            INNER JOIN Tbl_Products ON Tbl_Products.Product_Id = Ap.Product_Id  
            INNER JOIN Tbl_Room R ON R.Room_Id = Am.Room_Id 
            INNER JOIN Tbl_Floor ON R.Floor_Id = Tbl_Floor.Floor_Id 
            INNER JOIN Tbl_Block ON R.Block_Id = Tbl_Block.Block_Id 
            INNER JOIN Tbl_Campus ON R.Campus_Id = Tbl_Campus.Campus_Id  
            WHERE Am.Room_Id = @RoomID;
        END;
    ')
END;

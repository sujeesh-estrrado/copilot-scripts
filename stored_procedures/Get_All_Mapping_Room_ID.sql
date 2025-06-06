IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_All_Mapping_Room_ID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[Get_All_Mapping_Room_ID] 
(@AssetId bigint)  
As  
Begin  
Select Am.MappingID,Ap.Product_Id_Number,Am.Room_Id as RoomID,R.Room_Name+'' - ''+Tbl_Floor.Floor_Name+'' - ''+Tbl_Block.Block_Name as Room_Name,Tbl_Products.Product_Name, Am.Asset_Product_Id from  
      Tb_Asset_Facility_Mapping Am Inner join Tbl_Asset_Product_Id Ap on Ap.Asset_Product_Id=Am.Asset_Product_Id  
      inner join Tbl_Products on Tbl_Products.Product_Id =Ap.Product_Id  
      Inner Join Tbl_Room R on R.Room_Id=Am.Room_Id Inner Join
      Tbl_Floor ON R.Floor_Id = Tbl_Floor.Floor_Id INNER JOIN      
      Tbl_Block ON R.Block_Id = Tbl_Block.Block_Id INNER JOIN      
      Tbl_Campus ON R.Campus_Id = Tbl_Campus.Campus_Id  
      where 
      Am.Asset_Product_Id=@AssetId
  
End
    ')
END;

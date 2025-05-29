IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Roomname]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_Roomname] @Campus_Id bigint        
As          
Begin        
        
 SELECT    Tbl_Room.Room_Name+''-''+Tbl_Floor.Floor_Name+''-''+Tbl_Block.Block_Name as Room_Name ,Room_Id     
          
FROM         Tbl_Room INNER JOIN      
                      Tbl_Floor ON Tbl_Room.Floor_Id = Tbl_Floor.Floor_Id INNER JOIN      
                      Tbl_Block ON Tbl_Room.Block_Id = Tbl_Block.Block_Id INNER JOIN      
                      [Tbl_Organzations ] ON Tbl_Room.Campus_Id = [Tbl_Organzations ].Organization_Id      
      
where  [Tbl_Organzations ].Organization_Id= @Campus_Id      
END  
    ')
END

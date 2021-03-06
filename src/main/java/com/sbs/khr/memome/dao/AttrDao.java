package com.sbs.khr.memome.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.khr.memome.dto.Attr;

@Mapper
public interface AttrDao {
	Attr get(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code);

	int remove(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code);

	int setValue(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code, @Param("value") String value, @Param("expireDate") String expireDate);

	String getValue(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code);

	int updateValue(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code, @Param("value") String value, @Param("expireDate") String expireDate);

	List<Integer> getRelIdByTypeCodeSameMemberId(@Param("memberId") int memberId);
	
}


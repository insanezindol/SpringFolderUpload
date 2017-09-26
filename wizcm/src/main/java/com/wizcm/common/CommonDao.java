package com.wizcm.common;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

public class CommonDao {

	/** oracle ring DB의 SqlSession */
	@Autowired
	@Qualifier("ringDB")
	protected SqlSession ringDBSession;

	/** oracle ringstat DB의 SqlSession */
	@Autowired
	@Qualifier("ringstatDB")
	protected SqlSession ringstatDBSession;

	/** oracle ktmusic DB의 SqlSession */
	@Autowired
	@Qualifier("ktmusicDB")
	protected SqlSession ktmusicDBSession;

	/** mssql bell DB의 SqlSession */
	@Autowired
	@Qualifier("bellDB")
	protected SqlSession bellDBSession;

	/** mssql belllog DB의 SqlSession */
	@Autowired
	@Qualifier("bellLogDB")
	protected SqlSession belllogDBSession;

	/** mssql belletc DB의 SqlSession */
	@Autowired
	@Qualifier("bellEtcDB")
	protected SqlSession belletcDBSession;
}
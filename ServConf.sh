export LANG=c
#进入脚本所在目录
SCRIPT_PATH=$(dirname $0);
cd $SCRIPT_PATH;

USERNAME=`/usr/bin/whoami`
if [ $USERNAME != "root" ] 
	then
	echo "需要 root 用户执行 "
	exit 1;
fi

if [ -z /sbin/chkconfig ] 
	then
	echo "/sbin/chkconfig no found. quit!"
	exit 1;
	else
	echo "已配置开机启动的服务:"
	/sbin/chkconfig --list|grep ":on" |awk '{print $1}' 
fi

Serv_ON(){
    echo "set Service:$1 on."
   /sbin/chkconfig $1 on
    echo "complete;"
}

Serv_OFF(){
    echo "set Service:$1 off."
   /sbin/chkconfig $1 off
    echo "complete;"
}

echo "开始优化..."
LISTS=`ls $PWD/list/*.list 2>/dev/null`
[ -z "$LISTS" ] && exit 6
for i in $LISTS; do
	while read LINE
	do
  		Q=`/sbin/chkconfig --list|grep ":on" |awk '{print $1}' |grep $LINE`
  		if [ "$Q" ]
  			then
				Serv_OFF $Q 
  		fi  

	done < $i
done
echo "完成"

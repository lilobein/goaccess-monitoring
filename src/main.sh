#!/bin/bash

method1(){
    touch var1.log
    awk '{print}' log_*.log | sort -k9 -n > var1.log
    goaccess var1.log --log-format=COMBINED -o goaccess_report_by_log_var1.html
    python3 -m http.server 9304
}

method2(){
    touch var2.log
    awk '!seen[$1]++' log_*.log > var2.log
    goaccess var2.log --log-format=COMBINED -o goaccess_report_by_log_var2.html
    python3 -m http.server 9304
}

method3(){
    touch var3.log
    awk '$9 ~ /^[45][0-9][0-9]$/ { print $0 }' log_*.log > var3.log
    goaccess var3.log --log-format=COMBINED -o goaccess_report_by_log_var3.html
    python3 -m http.server 9304
}

method4(){
    touch var4.log
    awk '$9 ~ /^[45][0-9][0-9]$/ && !seen[$1]++' log_*.log > var4.log
    goaccess var4.log --log-format=COMBINED -o goaccess_report_by_log_var4.html
    python3 -m http.server 9304
}

if ls log_*.log 1> /dev/null 2>&1; then
    case $1 in
    1) method1
    ;;
    2) method2
    ;;
    3) method3
    ;;
    4) method4
    ;;
    *) echo "Лог-файлы найдены"
        goaccess log_*.log --log-format=COMBINED -o goaccess_report_by_log.html
        python3 -m http.server 9304;;
    esac
else
    echo "Ошибка: Файлы log_*.log не найдены, скорее всего скрипт 04 не запускался, или что-то случилось"
    exit 1
fi

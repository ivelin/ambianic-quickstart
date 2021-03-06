#!/bin/bash
INSTALLDIR=/opt/ambianic
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UI_URL="https://ui.ambianic.ai/"

sudo true

upgrade() {
    echo "Upgrading ambianic setup.."
    cd $INSTALLDIR && git pull origin $BRANCH && sh installer.sh
}

open_ui() {
    echo "Opening Ambianic.ai UI at $UI_URL"
    if command -v "xdg-open" &> /dev/null; then
        xdg-open $UI_URL
    else
       echo "xdg-open not available, please copy the link above to reach the UI."
    fi
}

logs() {
    cd $INSTALLDIR && sudo docker-compose logs -f --tail 100 ambianic-edge
}

status() {
    cd $INSTALLDIR && sudo docker-compose ps ambianic-edge
}

start() {
    cd $INSTALLDIR && sudo docker-compose up -d
}

kill_cmd() {
    cd $INSTALLDIR && sudo docker-compose kill && sudo docker-compose down
}

stop() {
    cd $INSTALLDIR && sudo docker-compose down
}

case "$1" in
    'start')
            start
            ;;
    'upgrade')
            upgrade
            ;;
    'stop')
            stop
            ;;
    'kill')
            kill_cmd
            ;;
    'restart')
            stop
            sudo rm -f /opt/ambianic/data/data/.__timeline-event-log.yaml.lock
            start
            ;;
    'status')
            status
            ;;
    'ps')
            status
            ;;
    'logs')
            logs
            ;;
    'ui')
            open_ui
            ;;
    *)
            CMD=$(basename $0)
            echo
            echo "Usage: $CMD { start | stop | restart | status | logs | ui | upgrade }"
            echo
            exit 1
            ;;
esac

exit 0